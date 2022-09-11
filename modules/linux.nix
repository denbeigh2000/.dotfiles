{ pkgs, host, ... }:

let
  inherit (host) graphical;
  graphicalModules = [ ./i3 ./noisetorch.nix ];
  graphicalPackages = with pkgs; [ nitrogen ];

in

{
  imports = [ ]
    ++ (if graphical then graphicalModules else [ ]);

  home = {
    packages = with pkgs; [ glibcLocales ]
      ++ (if graphical then graphicalPackages else [ ]);
  };

  fonts.fontconfig.enable = graphical;
  # NOTE: This must change if we're ever running on NixOS
  targets.genericLinux.enable = true;

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
