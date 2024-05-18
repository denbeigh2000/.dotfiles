{ pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (pkgs) writeShellApplication writeShellScriptBin;

  roulette = writeShellApplication {
    name = "roulette";

    text = readFile ./roulette.sh;
  };
in
{
  home.packages = [ roulette ];
}

