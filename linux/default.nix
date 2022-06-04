{ host
, pkgs ? import <nixpkgs>
}:

let
  common = {
    packages = with pkgs; [
      glibcLocales
    ];
  };

  graphical = {
    packages = with pkgs; [
      nitrogen
    ] ++ common.packages;
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
      i3-config = import ./i3/default.nix { inherit (host) hostname; };
      font-config = {
        target = ".config/fontconfig/conf.d/10-nix-conts.conf";
        text = builtins.readFile ./fontconfig.xml;
      };
    };
  };

  nonGraphical = {
    packages = common.packages;
    services = { };
    files = { };
  };

in
if host.graphical
then pkgs.lib.recursiveUpdate nonGraphical graphical
else nonGraphical
