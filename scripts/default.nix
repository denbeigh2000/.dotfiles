{ writeShellApplication
, symlinkJoin
, curl
, gnused
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
}
