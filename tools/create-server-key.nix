{ pkgs }:

pkgs.writeShellScriptBin "create-server-key" ''
  set -euo pipefail

  if [[ "$UID" -ne 0 ]]
  then
    echo "This script must be run as root" >&2
    exit 1
  fi

  if [[ -e /var/lib/denbeigh/host_key ]]
  then
    echo "Server key already exists at /var/lib/denbeigh/host_key" >&2
    exit 1
  else
    ${pkgs.coreutils}/bin/mkdir -p /var/lib/denbeigh
    ${pkgs.openssh}/bin/ssh-keygen -f /var/lib/denbeigh/host_key -t ed25519 -b 2048
    ${pkgs.coreutils}/bin/chmod 640 /var/lib/denbeigh/host_key
  fi
''
