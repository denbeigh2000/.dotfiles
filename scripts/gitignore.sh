#!/usr/bin/env bash

fix_urls() {
    sed 's|\btoptal.com/developers/gitignore\b|gitignore.io|g'
}

usage() {
    echo "USAGE"
    echo "$0 FILE_TYPE [FILE_TYPE [...]]"
}

join() {
    local IFS=","
    echo "$*"
}

if [[ $# -eq 0 ]]
then
    usage >&2
    exit 1
fi

if [[ $# -eq 1 ]]
then
    case "$1" in
        "--help" | "-h")
            usage >&2
            exit 0
            ;;
    esac
fi

curl \
    --location \
    --silent \
    "https://www.gitignore.io/api/$(join "$@")" \
    | fix_urls
