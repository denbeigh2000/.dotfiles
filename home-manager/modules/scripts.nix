{ pkgs, ... }:

let
  inherit (pkgs) writeShellScriptBin;

  roulette = writeShellScriptBin "roulette" ''
    if ! (( $RANDOM % 6 ))
    then
        $@
    else
        echo 'click'>&2
    fi
  '';
in
{
  home.packages = [ roulette ];
}
