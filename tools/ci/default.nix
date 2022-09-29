{ pkgs, ... }:

with pkgs; let
  # TODO: mkPipeline (attrset -> JSON)
  # TODO: uploadPipeline
  build = import ./build.nix { inherit pkgs; };
in
{
  inherit (build) ci devShell;
}
