{ self, pkgs, ... }:

{
  home.packages = with pkgs; [
    denbeigh.fonts.sf-mono
    denbeigh.fonts.sf-pro
    powerline-fonts
  ];
}
