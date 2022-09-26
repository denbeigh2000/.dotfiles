import json
from typing import Dict, Iterable, Optional

from ci import git
from ci.nix import DerivationInfo, Nix


def find_changes(
    n: Nix, base_branch: str = "master", commit: Optional[str] = None
) -> Dict[str, DerivationInfo]:
    # TODO: Want to compare to successful builds earlier on branch
    merge_base = git.get_merge_base(base_branch)

    from_eval = n.eval_codebase(merge_base)
    # .#blah -> /nix/store/...
    to_eval = n.eval_codebase(commit)

    # Annoingly, repeated evaluation is very slow, and we can only get bulk
    # evaluation keyed by output path.

    # TODO: Find a better place for wrangling the output of nix
    # show-derivation?

    keys = sorted([
        f'.#{k.split("#", 1)[1]}'
        for k, v in to_eval.items()
        if k not in from_eval or v != from_eval[k]
    ])

    # /nix/store/... -> .#blah
    path_to_key = {
        path: key
        for key in keys
        for (key, path) in to_eval.items()
    }

    derivations = n.show_derivations(path_to_key.keys())
    derivs_by_out_path = {
        deriv.output_path: deriv
        for deriv in derivations
    }

    return {
        path_to_key[str(k)]: v
        for (k, v) in derivs_by_out_path.items()
    }
