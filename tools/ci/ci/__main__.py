from typing import Optional, Sequence

import click
from ci.buildkite import build_derivations_step, upload_pipeline

from ci import delta, nix
from ci.constants import REPO_ROOT


@click.group()
def __main__() -> None:
    pass


@__main__.command()
def show_targets() -> None:
    n = nix.Nix()
    targets = n.find_buildable_targets()

    for target in targets:
        click.echo(target)


@__main__.command()
def show_unbuilt_derivations() -> None:
    n = nix.Nix()
    derivs = n.find_buildable_derivations()
    for d in derivs:
        if not d.is_built():
            click.echo(d.derivation_path)


@__main__.command()
@click.option("--branch", default=None, envvar="BUILDKITE_BRANCH")
@click.option(
    "--base-branch", default="master", envvar="BUILDKITE_PULL_REQUEST_BASE_BRANCH"
)
@click.option("--commit", default=None, envvar="BUILDKITE_COMMIT")
def show_changes(
    branch: Optional[str], base_branch: str, commit: Optional[str]
) -> None:
    n = nix.Nix()
    affected = delta.find_changes(n, base_branch, commit)

    unsorted_path = [ str(a.derivation_path) for a in affected.values()]
    paths = n.remove_absolute_flake_paths(sorted(unsorted_path))

    for item in paths:
        click.echo(item)


@__main__.command()
@click.option("--branch", default=None, envvar="BUILDKITE_BRANCH")
@click.option(
    "--base-branch", default="master", envvar="BUILDKITE_PULL_REQUEST_BASE_BRANCH"
)
@click.option("--commit", default=None, envvar="BUILDKITE_COMMIT")
def trigger_jobs_for_changes(branch: str, base_branch: str, commit: Optional[str]) -> None:
    n = nix.Nix()
    if branch == "master":
        affected = n.eval_codebase(commit)
    else:
        affected = delta.find_changes(n, base_branch, commit)

    targets = list(affected.values())

    if not targets:
        # Nothing to do
        return

    step = build_derivations_step(targets)
    upload_pipeline({"steps": [step]})


@__main__.command()
@click.argument("targets", nargs=-1, required=True)
def build_derivations(targets: Sequence[str]) -> None:
    n = nix.Nix()
    n.build_derivations(targets)


if __name__ == "__main__":
    __main__()
