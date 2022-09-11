{ fonts, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
in

{
  home.packages = with fonts.packages.${system}; [
    sf-mono
    sf-pro
    pkgs.powerline-fonts
  ];
}
