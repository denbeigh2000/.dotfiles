{ pkgs }:

let
  agenix-edit = import ./agenix-edit.nix { inherit pkgs; };
  create-server-key = import ./create-server-key.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "secrets-tools";
  paths = [ agenix-edit create-server-key ];
}
