{ pkgs, nixgl ? import <nixgl> {} }:

(pkg: (name: pkgs.writeShellScriptBin "${name}" ''
  ${nixgl.auto.nixGLDefault}/bin/nixGL exec ${pkg}/bin/${name} "$@"
''))
