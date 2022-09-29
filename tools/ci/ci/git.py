import subprocess

from ci.constants import REPO_ROOT


def get_sha(ref: str = "HEAD") -> str:
    return subprocess.run(
        ["git", "rev-parse", ref], cwd=REPO_ROOT, capture_output=True
    ).stdout.decode().strip()


def get_merge_base(other: str) -> str:
    return subprocess.run(
        ["git", "merge-base", other, "HEAD"], cwd=REPO_ROOT, capture_output=True
    ).stdout.decode().strip()
