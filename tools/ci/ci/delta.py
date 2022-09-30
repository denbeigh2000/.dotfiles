from typing import Dict, Optional

from ci import git
from ci.nix import DerivationInfo, Nix


def find_changes(
    n: Nix, base_branch: str = "master", commit: Optional[str] = None
) -> Dict[str, DerivationInfo]:
    # TODO: Want to compare to successful builds earlier on branch
    merge_base = git.get_merge_base(base_branch)

    # .#blah -> DerivationInfo
    from_eval = n.eval_codebase(merge_base)
    to_eval = n.eval_codebase(commit)

    return {
        k: v
        for k, v in to_eval.items()
        if k not in from_eval or v != from_eval[k]
    }
