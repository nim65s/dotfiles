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
parser.add_argument("-v", "--verbose", action="store_true")


def md5cron(project: str, verbose: bool = False) -> str:
    """
    main function.

    >>> md5cron("crocoddyl")
    0 21 12 * *
    """

    n = int(md5(project.encode()).hexdigest(), 16)
    hour, day = (n // 30) % 24, n % 30 + 1
    if verbose:
        print(f"# {project=}")
    return f"0 {hour} {day} * *"


if __name__ == "__main__":
    args = parser.parse_args()
    print(md5cron(args.project, args.verbose))
