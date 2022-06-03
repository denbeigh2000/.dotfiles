#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 [build|apply]" >&2
}

if [[ $# -eq 0 ]]
then
    COMMAND=apply
elif [[ $# -eq 1 ]]
then
    COMMAND="$1"
else
    usage
    exit 1
fi

case $COMMAND in
    "apply")
        HM_CMD="switch"
        ;;
    "build")
        HM_CMD="build"
        ;;
    *)
        usage
        exit 1;
        ;;
esac

HOSTNAME="${HOSTNAME:-$(hostname)}" home-manager switch -f home.nix
