{ pkgs, nixgl }:

(pkg: (name: pkgs.writeShellScriptBin "${name}" ''
  ${nixgl}/bin/nixGL exec ${pkg}/bin/${name} "$@"
''))
