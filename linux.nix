{ pkgs ? import <nixpkgs> }:

{
  packages = with pkgs; [ i3lock ];
  services = {
    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock}/bin/i3lock";
    };
  };
}
