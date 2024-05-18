#!/usr/bin/env bash

if ! (( RANDOM % 6 ))
then
    "$@"
else
    echo 'click'>&2
fi
