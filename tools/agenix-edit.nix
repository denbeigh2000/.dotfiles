{ pkgs }:

pkgs.writeShellScriptBin "agenix-edit" ''
  set -euo pipefail

  if [[ -e /var/lib/denbeigh/host_key ]]
  then
    ${pkgs.agenix}/bin/agenix -i /var/lib/denbeigh/host_key -e "$1"
  else
    ${pkgs.agenix}/bin/agenix -e "$1"
  fi
''
