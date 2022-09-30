import json
from subprocess import run
from tempfile import NamedTemporaryFile
from typing import Any, Dict, Sequence

from ci.constants import REPO_ROOT
from ci.nix import DerivationInfo, Nix


def build_derivations_step(derivs: Sequence[DerivationInfo]) -> Dict[str, Any]:
    n = len(derivs)
    assert n > 0, "received a list of no derivations to build"
    if n == 1:
        msg = derivs[0].name
    else:
        msg = f"{n} derivations"

    targets = Nix.remove_absolute_flake_paths(str(d.derivation_path) for d in derivs)
    targets = " ".join(targets)

    return {
        "label": f":hammer_and_wrench: building {msg}",
        "command": f"nix run .#ci build-derivations {targets}",
    }


def upload_pipeline(pipeline: Dict[str, Any]) -> None:
    with NamedTemporaryFile() as t:
        t.write(json.dumps(pipeline).encode("utf-8"))
        t.flush()

        run(["buildkite-agent", "pipeline", "upload", t.name])
