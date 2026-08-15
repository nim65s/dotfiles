"""Kal entrypoint."""

import argparse
import asyncio
import logging
import os

import gpio
import zenoh

from .daemon import Daemon

LOG = logging.getLogger("kal")


def parse_args() -> argparse.Namespace:
    """Check what the user want."""

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-q",
        "--quiet",
        action="count",
        default=int(os.environ.get("QUIET", "0")),
        help="decrement verbosity level",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=int(os.environ.get("VERBOSITY", "0")),
        help="increment verbosity level",
    )

    return parser.parse_args()


def main():
    """Start kal."""

    args = parse_args()

    if args.verbose == 0:
        level = os.environ.get("KAL_LOG_LEVEL", "WARNING")
    else:
        level = 30 - 10 * args.verbose
    logging.basicConfig(level=level)

    LOG.debug("parsed arguments: %s", args)

    relay = gpio.GPIOPin(17, gpio.OUT)

    with zenoh.open(zenoh.Config()) as session:
        daemon = Daemon(relay, session)
        asyncio.run(daemon.run())
