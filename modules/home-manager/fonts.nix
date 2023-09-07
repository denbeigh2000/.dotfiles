{ self, pkgs, ... }:

let
  inherit (pkgs.stdenvNoCC.hostPlatform) system;
  # TODO: Using overlays in standalone HM configs?
  inherit (self.inputs.fonts.packages.${system}) sf-mono sf-pro;
in
{
  nixpkgs.overlays = [ self.inputs.fonts.overlays.default ];
  home.packages = [
    sf-mono
    sf-pro
    pkgs.powerline-fonts
  ];
}
