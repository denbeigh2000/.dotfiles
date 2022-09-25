#!/usr/bin/env python3

from pathlib import Path
from subprocess import run


def _find_repo_root() -> Path:
    result = run(["git", "rev-parse", "--show-toplevel"], capture_output=True)
    assert result.stdout, "not in git directory?"
    return Path(result.stdout.decode().strip())


REPO_ROOT = _find_repo_root()
