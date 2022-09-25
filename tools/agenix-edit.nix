{ pkgs }:

pkgs.writeShellScriptBin "agenix-edit" ''
  set -euo pipefail

  if [[ "$UID" -ne 0 ]]
  then
    echo "This script must be run as root" >&2
    exit 1
  fi

  if [[ -e /var/lib/denbeigh/host_key ]]
  then
    ${pkgs.agenix}/bin/agenix -i /var/lib/denbeigh/host_key -e "$1"
  else
    ${pkgs.agenix}/bin/agenix -e "$1"
  fi
''
