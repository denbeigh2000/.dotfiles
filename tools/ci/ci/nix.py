import json
from dataclasses import dataclass
from pathlib import Path
from subprocess import run
from typing import Any, Dict, Iterable, List, Optional

from ci.constants import REPO_ROOT

_SYSTEM = "x86_64-linux"  # TODO: Improve this


@dataclass
class DerivationInfo:
    derivation_path: Path
    output_path: Path

    @classmethod
    def from_json(cls, key: str, data: Dict[str, Any]) -> "DerivationInfo":
        return cls(
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
        targets = self.find_buildable_targets()
        raw_deriv_info = run(["nix", "show-derivation"] + list(targets), capture_output=True)
        deriv_info = json.loads(raw_deriv_info.stdout)

        return [DerivationInfo.from_json(k, v) for k, v in deriv_info.items()]
