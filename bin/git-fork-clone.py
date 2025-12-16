#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["PyGithub"]
# ///

"""
Given a repo (or an owner), fork + clone + configure it (or all its repos):
- fork the upstream if it is not already forked
- clone the fork if it is not already cloned
- configure `upstream` and `origin` remotes
- fetch
- configure pull from upstream
- configure push to fork
"""

from logging import basicConfig, getLogger
from argparse import ArgumentParser
from pathlib import Path
from os import environ
from subprocess import check_output, DEVNULL, run

from github import Auth, Github
from github.GithubException import UnknownObjectException
from github.NamedUser import NamedUser
from github.Repository import Repository

GITHUB_HTTPS_URL = "https://github.com/"
GITHUB_SSH_URL = "git@github.com:"

logger = getLogger("ghf")

parser = ArgumentParser(prog="git fork-clone", description=__doc__)
parser.add_argument(
    "repo",
    default=".",
    nargs="?",
    help=f"'.', or repo, or owner/repo, or owner/, or {GITHUB_HTTPS_URL}owner/repo[/]",
)
parser.add_argument("branch", nargs="?", help="the branch to work on")
parser.add_argument("--github-url", default=environ.get("GITHUB_URL", GITHUB_SSH_URL))
parser.add_argument(
    "-v",
    "--verbose",
    action="count",
    default=int(environ.get("VERBOSITY", 0)),
    help="increment verbosity level",
)


def vrun(*cmd, **kwargs):
    logger.info("+ %s", " ".join(*cmd))
    run(*cmd, **kwargs)


def create_fork(
    upstream: Repository, origin_owner: str, origin_name: str | None = None
) -> Repository:
    """Just a fancy `upstream.create_fork()`"""
    upstream_owner = upstream.owner.login
    upstream_name = upstream.name
    logger.info(
        "Forking '%s/%s into '%s'...",
        upstream_owner,
        upstream_name,
        origin_owner,
    )
    origin = upstream.create_fork()
    logger.info("Forked '%s' into '%s'.", upstream, origin)
    return origin


class Fork:
    def __init__(
        self,
        gh: Github,
        repo: str,
        github_url: str,
        origin: NamedUser | str | None = None,
    ):
        if origin is None:
            origin = gh.get_user()
        origin_owner = str(origin.login if hasattr(origin, "login") else origin)
        logger.debug("origin_owner: %s", origin_owner)

        if "/" in repo:
            self.upstream = gh.get_repo(repo)
            for fork in self.upstream.get_forks():
                if fork.owner.login == origin_owner:
                    self.origin = fork
                    logger.debug(
                        "Using %s's existing fork at %s", self.upstream, self.origin
                    )
                    break
            else:
                self.origin = create_fork(self.upstream, origin_owner)
                logger.debug("Using %s fresh fork at %s", self.upstream, self.origin)
        else:
            name = Path.cwd().name if repo == "." else repo
            logger.debug("Looking for %s on %s", name, origin_owner)
            try:
                self.origin = gh.get_repo(f"{origin_owner}/{name}")
                if self.origin.fork:
                    self.upstream = self.origin.parent
                    logger.debug(
                        "Found %s and its usptream %s", self.origin, self.upstream
                    )
                else:
                    self.upstream = self.origin
                    logger.debug(
                        "Found that %s **is NOT a fork**. Use it as upstream anyway."
                    )
            except UnknownObjectException:
                logger.info(
                    "%s not found on %s, looking at existing remotes",
                    name,
                    origin_owner,
                )
                for remote in check_output(
                    ["git", "remote", "show", "-n"], text=True
                ).split():
                    logger.debug("checking remote '%s'", remote)
                    for url in check_output(
                        ["git", "remote", "show", "-n", remote], text=True
                    ).split():
                        if url.startswith(github_url):
                            logger.debug(
                                "found matching url '%s' in remote '%s'", url, remote
                            )
                            repo = (
                                url.removeprefix(github_url)
                                .removesuffix(".git")
                                .strip("/")
                            )
                            ghr = gh.get_repo(repo)
                            if ghr.fork:
                                self.origin = ghr
                                self.upstream = (
                                    self.origin.parent
                                    if self.origin.fork
                                    else self.origin
                                )
                                logger.debug(
                                    "use that '%s' as origin, and '%s' as upstream",
                                    self.origin,
                                    self.upstream,
                                )
                            else:
                                logger.debug("current directory origin is not a fork. ")
                                self.uptream = ghr
                                for fork in self.upstream.get_forks():
                                    if fork.owner.login == origin_owner:
                                        origin_name = fork.name
                                        self.origin = gh.get_repo(
                                            f"{origin_owner}/{origin_name}"
                                        )
                                        logger.debug(
                                            "use that '%s' as upstream, and '%s' as origin",
                                            self.upstream,
                                            self.origin,
                                        )
                                        break
                                else:
                                    logger.debug(
                                        "use that '%s' as upstream, and create a fork for origin",
                                        self.upstream,
                                    )
                                    self.origin = create_fork(
                                        self.uptream, origin_owner
                                    )
                            break
                    else:
                        continue
                    break
                else:
                    logger.error("no idea what to do.")

        self.origin_owner = self.origin.owner.login
        self.origin_name = self.origin.name
        self.upstream_owner = self.upstream.owner.login
        self.upstream_name = self.upstream.name

        logger.info(
            "working on %s/%s fork of %s/%s",
            self.origin_owner,
            self.origin_name,
            self.upstream_owner,
            self.upstream.name,
        )

    def clone(self, branch: str, github_url: str):
        # clone the fork if it is not already cloned

        if Path.cwd().name == self.upstream_name and Path(".git").exists():
            git = ["git"]
            logger.debug("Using already cloned current directory")
        else:
            git = ["git", "-C", self.upstream_name]
            if (
                Path(self.upstream_name).exists()
                and (Path(self.upstream_name) / ".git").exists()
            ):
                logger.debug("Using already cloned %s directory", self.upstream_name)
            else:
                clone = ["git", "clone"]
                if branch:
                    clone = [*clone, "--branch", branch]
                logger.info(
                    "Cloning '%s/%s' into %s...",
                    self.origin_owner,
                    self.origin_name,
                    self.upstream_name,
                )
                vrun(
                    [
                        *clone,
                        f"{github_url}{self.origin_owner}/{self.origin_name}",
                        self.upstream_name,
                    ],
                    check=True,
                )
                logger.info(
                    "Cloned '%s/%s' into %s.",
                    self.origin_owner,
                    self.origin_name,
                    self.upstream_name,
                )

        # configure `upstream` and `origin` remotes
        for remote, url in [
            ("upstream", f"{github_url}{self.upstream_owner}/{self.upstream_name}"),
            ("origin", f"{github_url}{self.origin_owner}/{self.origin_name}"),
        ]:
            if url not in check_output(
                [*git, "remote", "show", "-n", remote], text=True
            ):
                vrun([*git, "remote", "remove", remote], stderr=DEVNULL)
                logger.debug("Creating remote %s", remote)
                vrun([*git, "remote", "add", remote, url], check=True)

        # fetch
        logger.debug("Updating upstream/origin remotes")
        vrun([*git, "fetch", "--all", "--prune"])

        # configure pull from upstream
        if not branch:
            logger.debug("Get current branch")
            branch = check_output([*git, "branch", "--show-current"], text=True).strip()
        if f"remotes/upstream/{branch}" in check_output(
            [*git, "branch", "-a"], text=True
        ):
            logger.info("Configure %s to be pulled from upstream", branch)
            vrun(
                [*git, "branch", f"--set-upstream-to=upstream/{branch}", branch],
                check=True,
            )
        else:
            logger.info("%s is not available  upstream", branch)
        for b in check_output([*git, "branch", "-a"], text=True).split("\n"):
            if "remotes/upstream/HEAD" not in b:
                continue
            main_branch = b.strip().split("/")[-1]
            if main_branch == branch:
                break
            logger.info("Configure %s to be pulled from upstream", main_branch)
            vrun([*git, "switch", "-C", main_branch, "-t", "upstream"], check=True)
            vrun([*git, "switch", branch], check=True)
            break

        # configure push to origin
        logger.info("Configure pushes to fork")
        vrun([*git, "config", "remote.pushDefault", "origin"], check=True)


def main(gh: Github, repo: str, branch: str, github_url: str, **kwargs):
    if repo.startswith(GITHUB_HTTPS_URL):
        repo = repo.removeprefix(GITHUB_HTTPS_URL).strip("/")

    if repo.endswith("/"):
        # We want to fork/clone every non-archived repo of this owner
        upstream_owner = repo.removesuffix("/")
        owner = gh.get_user(upstream_owner)
        for ghr in owner.get_repos():
            if not ghr.archived:
                repo = f"{ghr.owner.login}/{ghr.name}"
                fork = Fork(gh, repo, github_url)
                fork.clone(branch, github_url)
    else:
        fork = Fork(gh, repo, github_url)
        fork.clone(branch, github_url)


if __name__ == "__main__":
    if "GITHUB_TOKEN" in environ:
        token = environ["GITHUB_TOKEN"]
    elif "GITHUB_TOKEN_CMD" in environ:
        token = check_output(environ["GITHUB_TOKEN_CMD"].split(), text=True).strip()
    else:
        err = "missing GITHUB_TOKEN or GITHUB_TOKEN_CMD"
        raise RuntimeError(err)

    args = parser.parse_args()
    basicConfig(level=50 - 10 * args.verbose)
    auth = Auth.Token(token)

    with Github(auth=auth) as gh:
        main(gh, **vars(args))
