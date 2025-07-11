#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["httpx"]
# ///

# I used to include patches in flake inputs, like:
# ```nix
#   inputs.patch-arsenik = {
#     url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/386205.patch";
#     flake = false;
#   };
# ```
# but github rate limits this way too much now, because IA.
#
# So now we have this.

"""
This will accept a PR url to download as patch, and/or update the current patches
as `patches/<owner>/<repo>/<pr>_<slug>.patch` (or only <pr>_<slug>.patch if --alone)

NB: updates involve a removal first and a download afterwards.
Use at your own risk, and preferably with a VCS.
"""

from unicodedata import normalize
from asyncio import run, gather
from logging import basicConfig, getLogger
from argparse import ArgumentParser
from pathlib import Path
from os import chdir, environ
from re import search, sub
from subprocess import check_output

from httpx import AsyncClient

PATTERN = r"(?P<owner>[^/]+)/(?P<repo>[^/]+)/pull/(?P<pr>\d+)"
PATCHES = Path("patches")


logger = getLogger("pratches")

parser = ArgumentParser(prog="pratches", description=__doc__)
parser.add_argument(
    "pr", nargs="?", help=f"a PR to add, as a string containing {PATTERN}"
)
parser.add_argument(
    "--only", action="store_true", help="when adding a PR, don't update the others"
)
parser.add_argument(
    "--here", action="store_true", help="don't cd into toplevel dir first"
)
parser.add_argument(
    "--alone", action="store_true", help="don't use patches/<owner>/<repo> structure"
)
parser.add_argument(
    "-q",
    "--quiet",
    action="count",
    default=int(environ.get("QUIET", 0)),
    help="decrement verbosity level",
)

parser.add_argument(
    "-v",
    "--verbose",
    action="count",
    default=int(environ.get("VERBOSITY", 0)),
    help="increment verbosity level",
)


def slugify(text: str) -> str:
    # ref. django/utils/text.py
    text = normalize("NFKD", text).encode("ascii", "ignore").decode("ascii")
    text = sub(r"[^\w\s-]", "", text)
    return sub(r"[-\s]+", "-", text).strip("-").lower()


async def dl(client: AsyncClient, owner: str, repo: str, pr: int, alone: bool):
    logger.info("processing: %s/%s/pull/%s", owner, repo, pr)
    dir = Path() if alone else PATCHES / owner / repo
    dir.mkdir(parents=True, exist_ok=True)
    url = f"https://api.github.com/repos/{owner}/{repo}/pulls/{pr}"

    data = await client.get(url)
    data.raise_for_status()
    data = data.json()
    if data.get("merged"):
        logger.warning(
            "Already merged: %s/%s/pull/%s (%s)", owner, repo, pr, data["title"]
        )
    else:
        logger.debug(
            "Not yet merged: %s/%s/pull/%s (%s)", owner, repo, pr, data["title"]
        )
    title = slugify(data["title"])

    patch = await client.get(url, headers={"Accept": "application/vnd.github.v3.patch"})
    patch.raise_for_status()

    file = dir / f"{pr}_{title}.patch"
    logger.debug("writing %s", file)
    file.write_text(patch.text)


async def main(token: str, pr: str | None, only: bool, alone: bool, **kwargs):
    patches = []
    if pr:
        m = search(PATTERN, pr)
        patches.append((m["owner"], m["repo"], m["pr"]))
    if not only and not alone:
        PATCHES.mkdir(exist_ok=True)
        for owner in PATCHES.iterdir():
            if not owner.is_dir():
                continue
            for repo in owner.iterdir():
                if not repo.is_dir():
                    continue
                for pr in repo.glob("*_*.patch"):
                    patches.append(
                        (
                            owner.name,
                            repo.name,
                            int(pr.name.split("_")[0]),
                        )
                    )
                    logger.debug("removing %s", pr)
                    pr.unlink()

    logger.debug("patches: %s", str(patches))
    async with AsyncClient(headers={"Authorization": f"token {token}"}) as client:
        await gather(*[dl(client, *patch, alone) for patch in patches])


if __name__ == "__main__":
    if "GITHUB_TOKEN" in environ:
        token = environ["GITHUB_TOKEN"]
    elif "GITHUB_TOKEN_CMD" in environ:
        token = check_output(environ["GITHUB_TOKEN_CMD"].split(), text=True).strip()
    else:
        err = "missing GITHUB_TOKEN or GITHUB_TOKEN_CMD"
        raise RuntimeError(err)

    args = parser.parse_args()

    basicConfig(level=30 - 10 * args.verbose + 10 * args.quiet)

    if args.here or args.alone:
        logger.info("Staying in %s", Path())
    else:
        toplevel = check_output(
            ["git", "rev-parse", "--show-toplevel"], text=True
        ).strip()
        logger.info("Updating patches in %s", toplevel)
        chdir(toplevel)

    run(main(token, **vars(args)))
