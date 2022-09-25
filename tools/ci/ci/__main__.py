import subprocess

import click

from ci import nix


@click.group()
def __main__():
    pass


@__main__.command()
def show_targets():
    n = nix.Nix()
    targets = n.find_buildable_targets()

    for target in targets:
        click.echo(target)


@__main__.command()
def show_unbuilt_derivations():
    n = nix.Nix()
    derivs = n.find_buildable_derivations()
    for d in derivs:
        if not d.is_built():
            click.echo(d.derivation_path)


if __name__ == "__main__":
    __main__()
