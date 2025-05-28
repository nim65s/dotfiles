#!/usr/bin/env python3

from pathlib import Path
from typing import List, Union
from subprocess import Popen, check_output
from time import sleep
from sys import argv, exit


def pmapnitor(
    cmd: List[str], output_file: Union[str, Path] = "/tmp/pmapnitor", period: float = 1
) -> int:
    output_file = Path(output_file)
    p = Popen(cmd)
    with output_file.open("a") as f:
        print(f"pid {p.pid}:", " ".join(cmd), file=f)
    while p.poll() is None:
        output = check_output(["pmap", str(p.pid)], text=True)
        output = output.strip().split("\n")[-1].split()[1].strip("K")
        with output_file.open("a") as f:
            print(output, file=f)
        sleep(period)
    return p.returncode


if __name__ == "__main__":
    exit(pmapnitor(argv[1:]))
