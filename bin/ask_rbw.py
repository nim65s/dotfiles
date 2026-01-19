#!/usr/bin/env python
"""Pinentry wrapper which ask ssh passphrase to rbw."""

import sys
from argparse import ArgumentParser
from os import environ
from shutil import which
from socket import gethostname
from subprocess import PIPE, CalledProcessError, Popen, check_output
from urllib.parse import quote

HOST = environ.get("ASK_RBW_HOST", gethostname())
PINENTRY = environ.get("ASK_RBW_PINENTRY", "pinentry-qt")

parser = ArgumentParser(description=__doc__)
parser.add_argument("-H", "--host", default=HOST)
parser.add_argument("-p", "--pinentry", default=PINENTRY)
parser.add_argument("prompt")


def main(prompt, host, pinentry):
    print(f"ask_rbw: {prompt=}, {host=}, {pinentry=}", file=sys.stderr)
    if "passphrase" in prompt.lower():
        if "'" in prompt:
            key = prompt.split("'")[1]
        else:
            key = prompt.strip().split()[-1][:-1]
        run = ["rbw", "get", "--folder", f"ssh/{host}", key]
        print(f"{run=}", file=sys.stderr)
        try:
            print(check_output(run, text=True))
        except CalledProcessError:
            # rbw-agent might be broken, let's restart it
            restart = ["rbw", "stop-agent"]
            print(f"{restart=}", file=sys.stderr)
            check_output(restart, text=True)
            # And then try again
            print(f"{run=}", file=sys.stderr)
            print(check_output(run, text=True))
    elif "are you sure" in prompt.lower():
        wrap(pinentry, prompt, "confirm")
    elif "password" in prompt.lower():
        wrap(pinentry, prompt, "getpin")
    else:
        print("I don't know what to do.", file=sys.stderr)


def wrap(pinentry, prompt, cmd):
    # TODO: check with run(..., input=data)
    p = Popen(which(pinentry), stdin=PIPE, stdout=PIPE, text=True)
    data = f"setdesc {quote(prompt)}\n{cmd}\nbye\n"
    print(f"{which(pinentry)=} {data=}", file=sys.stderr)
    out, _ = p.communicate(input=data)
    if cmd == "getpin":
        if "ERR" in out:
            print(f"fail: {out=}", file=sys.stderr)
        else:
            print(next(i for i in out.split("\n")[2:] if i.startswith("D "))[2:])
    else:
        print("No" if "ERR" in out else "Yes")


if __name__ == "__main__":
    main(**vars(parser.parse_args()))
