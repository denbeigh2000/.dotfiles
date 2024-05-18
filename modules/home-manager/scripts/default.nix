{ pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (pkgs) writeShellApplication writeShellScriptBin;

  roulette = writeShellApplication {
    name = "roulette";

    text = readFile ./roulette.sh;
  };

  gitignore = writeShellApplication {
    name = "gitignore";

    runtimeInputs = with pkgs; [ gnused curl ];
    text = readFile ./gitignore.sh;
  };
in
{
  home.packages = [ gitignore roulette ];
}

