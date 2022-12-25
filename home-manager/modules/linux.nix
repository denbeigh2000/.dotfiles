{ pkgs, host, ... }:

let
  inherit (host) graphical isNixOS;
  graphicalModules = [ ./i3 ./autorandr ];
  graphicalPackages = with pkgs; [ nitrogen ];

  locations = import ../../locations.nix;
  location = locations.${host.location};
in

{
  imports = [ ./noisetorch.nix ]
    ++ (if graphical then graphicalModules else [ ]);

  home = {
    packages = with pkgs; [ glibcLocales ]
      ++ (if graphical then graphicalPackages else [ ]);
  };

  fonts.fontconfig.enable = true;
  targets.genericLinux.enable = !isNixOS;

  services = {
    dunst.enable = graphical;
    noisetorch.enable = graphical;
    redshift = {
      enable = graphical;
      temperature = {
        day = 5500;
        night = 3700;
      };
      tray = true;
    } // location.coords;
  };
}
