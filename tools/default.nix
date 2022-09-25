{ pkgs }:

let
  secrets = import ./secrets { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "tools";
  paths = [ secrets ];
}
