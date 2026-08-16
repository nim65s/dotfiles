"""Kal entrypoint."""

import argparse
import asyncio
import logging
import os
import pathlib

import gpiod
import zenoh
from gpiod.line import Direction, Value

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
        level = os.environ.get("KAL_LOG_LEVEL", "WARNING").upper()
    else:
        level = 30 - 10 * args.verbose
    logging.basicConfig(level=level)

    LOG.debug("parsed arguments: %s", args)

    chip_path = "/dev/gpiochip0"
    assert pathlib.Path(chip_path).exists()
    with gpiod.Chip(chip_path) as chip:
        LOG.debug("chip: %s", chip)

    config = zenoh.Config()
    config.insert_json5("connect/endpoints", '["tcp/127.0.0.1:7447"]')

    with (
        gpiod.request_lines(
            chip_path,
            consumer="kal",
            config={
                17: gpiod.LineSettings(
                    direction=Direction.OUTPUT, output_value=Value.INACTIVE
                )
            },
        ) as relay,
        zenoh.open(config) as session,
    ):
        LOG.debug("relay: %s", relay)
        daemon = Daemon(relay, session)
        asyncio.run(daemon.run())
