{ writeShellApplication
, symlinkJoin
, curl
, gnused
, ripgrep
, scowl
, coreutils
}:

let
  inherit (builtins) readFile;
in
{
  roulette = writeShellApplication {
    name = "roulette";

    text = readFile ./roulette.sh;
  };

  gitignore = writeShellApplication {
    name = "gitignore";

    runtimeInputs = [ gnused curl ];
    text = readFile ./gitignore.sh;
  };

  grid = writeShellApplication {
    name = "grid";

    runtimeInputs = [ ripgrep coreutils ];
    text = ''
      WORDLIST_DIR="${scowl}/share/dict"

      ${readFile ./grid.sh}
    '';
  };
}
