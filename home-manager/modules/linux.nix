{ pkgs, host, ... }:

let
  inherit (host) graphical isNixOS;
  graphicalModules = [ ./i3 ];
  graphicalPackages = with pkgs; [ nitrogen ];

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
      latitude = 37.7749;
      longitude = -122.4194;
      temperature = {
        day = 5500;
        night = 3700;
      };
      tray = true;
    };
  };
}
