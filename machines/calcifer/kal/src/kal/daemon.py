"""Kal daemon."""

import asyncio
import logging

import gpiod
import zenoh
from gpiod.line import Value

from .mode import Mode
from .schedule import Schedule
from .temperature import Temperature
from .time import Time

LOG = logging.getLogger("kal.daemon")


class AsyncQueueThreadSafe(asyncio.Queue):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.loop = asyncio.get_running_loop()

    def put_threadsafe(self, item):
        return self.loop.call_soon_threadsafe(self.put_nowait, item)


class Daemon:
    def __init__(self, relay: gpiod.LineRequest, session: zenoh.Session):

        mode = Mode.default()

        for response in session.get("kal/cmnd/daemon/mode"):
            if reply := response.ok:
                mode = Mode.from_str(reply.payload.to_string())
                LOG.info("mode %s", mode)

        self.schedule = Schedule.default()
        self.mode = mode
        self.session = session
        self.relay = relay
        self.subscribers = []

    async def run(self):
        daemon_queue = AsyncQueueThreadSafe()
        temperature_queue = AsyncQueueThreadSafe()

        self.subscribers = [
            self.session.declare_subscriber(
                "kal/cmnd/daemon/*", daemon_queue.put_threadsafe
            ),
            self.session.declare_subscriber(
                "kal/tele/tasmota_43D8FD/temperature", temperature_queue.put_threadsafe
            ),
        ]

        async with asyncio.TaskGroup() as tg:
            tg.create_task(self.daemon_task(daemon_queue))
            tg.create_task(self.temperature_task(temperature_queue))

        LOG.info("Daemon run shutdown")

    async def daemon_task(self, queue: asyncio.Queue):
        LOG.debug("start daemon task")
        while sample := await queue.get():
            if sample.key_expr.ends_with("/mode"):
                self.mode = Mode.from_sample(sample)
                LOG.info("mode %s", self.mode)
                self.session.put("kal/tele/daemon/mode", self.mode.to_string())
                if self.mode != Mode.AUTO:
                    self.set_relay(bool(self.mode))
            elif sample.key_expr.ends_with("/schedule"):
                self.schedule = Schedule.from_sample(sample)
                LOG.info("set schedule %s", self.schedule)
            elif sample.key_expr.ends_with("/get"):
                self.session.put("kal/tele/daemon/schedule", self.schedule.to_string())
                self.session.put("kal/tele/daemon/mode", self.mode.to_string())

    async def temperature_task(self, queue: asyncio.Queue):
        LOG.debug("start temperature task")
        while sample := await queue.get():
            t = Temperature(float(sample.payload.to_string()))
            LOG.debug("received %s", t)
            match self.mode:
                case Mode.ON:
                    self.set_relay(True)
                case Mode.OFF:
                    self.set_relay(False)
                case Mode.AUTO:
                    target = self.schedule.target(Time.now())
                    self.session.put("kal/tele/daemon/target", f"{target:.3f}")
                    self.set_relay(t < target)

    def set_relay(self, v: bool):
        p = "On" if v else "Off"
        LOG.debug("relay %s", p)
        self.session.put("kal/tele/daemon/relay", p)
        self.relay.set_value(17, Value.ACTIVE if v else Value.INACTIVE)
