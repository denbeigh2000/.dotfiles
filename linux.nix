{ host
, pkgs ? import <nixpkgs>
}:

let
  graphical = {
    packages = with pkgs; [
      nitrogen
    ];
    services = {
      dunst = {
        enable = true;
      };
      redshift = {
        enable = true;
        latitude = 37.7749;
        longitude = -122.4194;
        temperature = {
          day = 5500;
          night = 3700;
        };
        tray = true;
      };
    };
    files = {
      i3-config = import ./i3/default.nix { configuration = host.graphical; };
    };
  };

  nonGraphical = {
    packages = with pkgs; [
      glibcLocales
    ];
    services = { };
    files = { };
  };
in
if host.graphical == null
then nonGraphical
else pkgs.lib.recursiveUpdate nonGraphical graphical
