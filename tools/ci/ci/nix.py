import json
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path
from subprocess import run
from typing import Any, Dict, Iterable, List, Optional, Set

from ci.constants import REPO_ROOT

from ci import git

_SYSTEM = "x86_64-linux"  # TODO: Improve this

# TODO: singulars (e.g., devShell)
# TODO: Maybe other evalable items I don't really use yet - checks, tasks, etc.
_EVALABLE_ITEMS_ARCH = {"packages", "devShells"}
# TODO: This causes problems with my current assumptions because there's
# not one specific output path (causes problems with `nix show-derivation`
# _EVALABLE_ITEMS_NO_ARCH = {"nixosConfigurations"}
_EVALABLE_ITEMS_NO_ARCH: Set[str] = set()
_EVALABLE_ITEMS = _EVALABLE_ITEMS_ARCH.union(_EVALABLE_ITEMS_NO_ARCH)


@dataclass
class DerivationInfo:
    name: str
    derivation_path: Path
    output_path: Path

    @classmethod
    def from_json(cls, key: str, data: Dict[str, Any]) -> "DerivationInfo":
        return cls(
            name=data["env"]["name"],
            derivation_path=Path(key),
            output_path=Path(data["outputs"]["out"]["path"]),
        )

    def is_built(self) -> bool:
        return self.output_path.exists()


def _find_in_dict(data: Dict[str, Any], key: List[str]) -> Optional[Any]:
    d = data
    for k in key:
        d = d.get(k, None)
        if d is None:
            return None

    return d


# TODO: Use this to find buildable target groups, then contained derivations
def _find_derivations(data: Any) -> Iterable[List[str]]:
    found: List[List[str]] = []

    for k, v in data.items():
        # print(k, v)
        if not isinstance(v, dict):
            # Only continue traversing if we're
            continue

        if v.get("type") == "derivation":
            found = found + [[k]]
            continue

        contained = [[k] + d for d in _find_derivations(v)]
        if contained:
            found = found + contained

    return found


class Nix:
    def __init__(self):
        pass

    @lru_cache()
    def show_flake(self) -> Dict[str, Any]:
        proc = run(
            ["nix", "flake", "show", "--json"], capture_output=True, cwd=REPO_ROOT
        )
        assert proc.stdout, "flake output empty, not in a flake directory?"
        return json.loads(proc.stdout)

    def find_buildable_targets(self) -> Iterable[str]:
        data = self.show_flake()
        derivations = _find_derivations(data)

        return [f'.#{".".join(d)}' for d in derivations if _SYSTEM in d]

    def find_buildable_derivations(self) -> Iterable[DerivationInfo]:
        return self.show_derivations(self.find_buildable_targets())

    def show_derivations(self, targets: Iterable[str]) -> List[DerivationInfo]:
        raw_deriv_info = run(
            ["nix", "show-derivation"] + list(targets), capture_output=True
        )
        deriv_info = json.loads(raw_deriv_info.stdout)

        return [DerivationInfo.from_json(k, v) for k, v in deriv_info.items()]

    def build_derivations(self, targets: Iterable[str]) -> None:
        cmd = ["nix", "build"] + list(targets)
        run(cmd)

    def eval_codebase(self, rev: Optional[str] = None) -> Dict[str, DerivationInfo]:
        flake_data = self.show_flake()
        relevant_keys = set(flake_data.keys()).intersection(_EVALABLE_ITEMS)
        uri_prefix = f"{REPO_ROOT}"
        if rev is not None:
            if len(rev) != 40:
                rev = git.get_sha(rev)
            uri_prefix += f"?rev={rev}"

        targets = {}

        for category in relevant_keys:
            key = f"{uri_prefix}#{category}"
            items = flake_data.get(category)
            if not items:
                # TODO
                continue

            if category in _EVALABLE_ITEMS_ARCH:
                key += f".{_SYSTEM}"
                items = items.get(_SYSTEM)
                if not items:
                    # TODO
                    continue

            for item_key in items:
                flake_key = f"{key}.{item_key}"
                proc = run(["nix", "show-derivation", flake_key], capture_output=True)
                info = list(json.loads(proc.stdout).values())[0]
                targets[flake_key] = DerivationInfo.from_json(flake_key, info)

        return targets
