#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "$0" "MIDDLE_LETTER" "OTHER_LETTERS" >&2
}

if [[ "$#" -ne 2 ]]
then
    usage
    exit 1
fi

MIDDLE_LETTER="$1"
OTHER_LETTERS="$2"
shift 2

MIDDLE_LEN="$(printf '%s' "$MIDDLE_LETTER" | wc -m)"
if [[ "$MIDDLE_LEN" -ne 1 ]]
then
    echo "found $MIDDLE_LEN middle characters, expected 1" >&2
    exit 1
fi

OTHER_LEN="$(printf '%s' "$OTHER_LETTERS" | wc -m)"
if [[ "$OTHER_LEN" -ne 6 ]]
then
    echo "found $OTHER_LEN other characters, expected 6" >&2
    exit 1
fi


rg --no-filename "^[${OTHER_LETTERS}${MIDDLE_LETTER}]*${MIDDLE_LETTER}[${OTHER_LETTERS}${MIDDLE_LETTER}]*\$" "$WORDLIST_DIR"/* \
    | rg '.{4,}' \
    | sort \
    | uniq
