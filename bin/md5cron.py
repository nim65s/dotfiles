#!/usr/bin/env python
"""
Given a project name, generate a deterministic day/hour
and print it in a cron format
"""

from argparse import ArgumentParser
from hashlib import md5
from pathlib import Path

parser = ArgumentParser(description=__doc__)
parser.add_argument("project", default=Path.cwd().name, nargs="?")


def md5cron(project: str) -> str:
    """
    main function.

    >>> md5cron("crocoddyl")
    0 21 12 * *
    """

    n = int(md5(project.encode()).hexdigest(), 16)
    hour, day = (n // 30) % 24, n % 30 + 1
    print(f"# {project=}")
    print(f"0 {hour} {day} * *")


if __name__ == "__main__":
    args = parser.parse_args()
    md5cron(args.project)
