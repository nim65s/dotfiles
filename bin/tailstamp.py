#!/usr/bin/env python

from datetime import datetime
from sys import stdin


def tailstamp():
    try:
        for line in stdin:
            now = datetime.now()  # noqa: DTZ005
            print(f"{now:%X} {line}", end="")
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    tailstamp()
