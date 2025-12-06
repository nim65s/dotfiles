#!/usr/bin/env python

from sys import stdin
from datetime import datetime


def tailstamp():
    try:
        for line in stdin:
            now = datetime.now()
            print(f"{now:%X} {line.strip('\n')}")
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    tailstamp()
