#!/usr/bin/env bash

set -euo pipefail

USER_NAME="$1"
ENV="${2:-prod}"

# TODO: This should also just import the thing in TF

aws iam create-access-key \
    --user-name "credible-$ENV-device-$USER_NAME"\
    --output json | jq .
