{ host
, pkgs ? import <nixpkgs> }:

let
  graphical = {
    packages = with pkgs; [
      i3lock
      nitrogen
    ];
    services = {
      dunst = {
        enable = true;
      };
      screen-locker = {
        enable = true;
        lockCmd = "${pkgs.i3lock}/bin/i3lock";
      };
    };
    files = {
      i3-config = import ./i3/default.nix { configuration = host.graphical; };
    };
  };

  nonGraphical = {
    packages = {};
    services = {};
    files = {};
  };
in
  if host.graphical == null
  then nonGraphical
  else nonGraphical // graphical
