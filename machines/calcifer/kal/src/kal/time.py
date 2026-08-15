from datetime import datetime
from zoneinfo import ZoneInfo


class Time:
    MIN: int = 0
    MAX: int = 24 * 60

    def __init__(self, value: int = 0):
        assert self.MIN <= value <= self.MAX
        self._value: int = value

    def __str__(self):
        return f"{self._value / 60:02}H{self._value % 60:02}"

    def json(self) -> str:
        return str(self._value)

    def __hash__(self) -> int:
        return self._value

    def __eq__(self, other) -> bool:
        if isinstance(other, int):
            other = Time(other)
        elif isinstance(other, float):
            other = Time.from_hours(other)
        elif not isinstance(other, Time):
            return False
        return self._value == other._value

    def __ge__(self, other) -> bool:
        if isinstance(other, int):
            other = Time(other)
        elif not isinstance(other, Time):
            return False
        return self._value >= other._value

    def __gt__(self, other) -> bool:
        if isinstance(other, int):
            other = Time(other)
        elif not isinstance(other, Time):
            return False
        return self._value > other._value

    def __le__(self, other) -> bool:
        if isinstance(other, int):
            other = Time(other)
        elif not isinstance(other, Time):
            return False
        return self._value <= other._value

    def __lt__(self, other) -> bool:
        if isinstance(other, int):
            other = Time(other)
        elif not isinstance(other, Time):
            return False
        return self._value < other._value

    def __sub__(self, other) -> int:
        if isinstance(other, int):
            other = Time(other)
        return self._value - other._value

    @classmethod
    def now(cls):
        tz = ZoneInfo("Europe/Paris")
        return cls.from_datetime(datetime.now(tz=tz))

    @classmethod
    def from_datetime(cls, dt: datetime):
        return cls(dt.hour * 60 + dt.minute)

    @classmethod
    def from_hours(cls, hours: float):
        return cls(int(hours * 60.0))
