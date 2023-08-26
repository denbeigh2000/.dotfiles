{ self, pkgs, ... }:

{
  nixpkgs.overlays = [
    self.inputs.fonts.overlays.default
  ];

  home.packages = with pkgs; [
    denbeigh.fonts.sf-mono
    denbeigh.fonts.sf-pro
    powerline-fonts
  ];
}
