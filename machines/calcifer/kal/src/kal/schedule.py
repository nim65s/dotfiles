import itertools
import json
import logging

import zenoh

from .temperature import Temperature
from .time import Time

LOG = logging.getLogger("kal.schedule")


class Schedule:
    """
    >>> s = Schedule.default()
    >>> s.auto(Time.from_hours(0.0), Temperature(13.0))
    True
    >>> s.auto(Time.from_hours(0.0), Temperature(15.0))
    False
    >>> s.auto(Time.from_hours(5.0), Temperature(15.0))
    True
    >>> s.auto(Time.from_hours(5.0), Temperature(16.0))
    False
    >>> s.auto(Time.from_hours(5.1), Temperature(16.0))
    False
    >>> s.auto(Time.from_hours(7.9), Temperature(16.0))
    True
    >>> s.auto(Time.from_hours(24.0), Temperature(13.0))
    True
    >>> s.auto(Time.from_hours(24.0), Temperature(15.0))
    False
    >>> j = '{"points":{"0":14.0,"300":15.5,"420":17.0,"1320":17.0,"1440":14.0}}'
    >>> j_s = Schedule.from_str(j)
    >>> s == j_s
    True
    >>> s_str = s.to_string()
    >>> j == s_str
    True
    """

    def __init__(self, temperature: Temperature):
        self._points: dict[Time, Temperature] = {
            Time.from_hours(0.0): temperature,
            Time.from_hours(24.0): temperature,
        }
        self._sorted: list[tuple[Time, Temperature]] = []
        self._segments = []
        self.update()

    @classmethod
    def default(cls):
        self = cls(Temperature(14.0))
        self._points[Time.from_hours(5.0)] = Temperature(15.5)
        self._points[Time.from_hours(7.0)] = Temperature(17.0)
        self._points[Time.from_hours(22.0)] = Temperature(17.0)
        self.update()
        return self

    def insert(self, time: Time, temperature: Temperature):
        self._points[time] = temperature
        self.update()

    def update(self):
        self._sorted = sorted(self._points.items())
        self._segments = list(itertools.pairwise(self._sorted))

    def remove(self, time: Time):
        if Time.MIN < time < Time.MAX:
            self._points.pop(time)

    def target(self, t: Time) -> Temperature:
        LOG.debug("current: %s", t)
        for (t1, v1), (t2, v2) in self._segments:
            if t1 <= t <= t2:
                LOG.debug("segment: %.2f @ %s -> %.2f @ %s", v1, t1, v2, t2)
                ratio = (t - t1) / (t2 - t1)
                return Temperature(v1 + (v2 - v1) * ratio)

    def auto(self, t: Time, v: Temperature) -> bool:
        return v < self.target(t)

    @classmethod
    def from_str(cls, s: str):
        self = cls(Temperature(14.0))
        self._points = {
            Time(int(k)): Temperature(v) for k, v in json.loads(s)["points"].items()
        }
        self.update()
        return self

    @classmethod
    def from_sample(cls, sample: zenoh.Sample):
        return cls.from_str(sample.payload.to_string())

    def to_string(self) -> str:
        return json.dumps(
            {"points": {k.json(): v for k, v in self._sorted}}, separators=(",", ":")
        )

    def __eq__(self, other) -> bool:
        if isinstance(other, Schedule):
            return self._sorted == other._sorted
        return False
