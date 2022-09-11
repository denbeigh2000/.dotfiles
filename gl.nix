{ pkgs }:

(pkg: (name: pkgs.writeShellScriptBin "${name}" ''
  ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkg}/bin/${name} "$@"
''))
