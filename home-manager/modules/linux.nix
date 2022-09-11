{ pkgs, host, ... }:

let
  inherit (host) graphical;
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

  #error: The option `home-manager.users.denbeigh.fonts.fontconfig.enable' has conflicting definition values:
  #     - In `/nix/store/3wkyg6016v4fri2dw07wzjm9g3r1vmwr-source/modules/linux.nix': false
  #     - In `/nix/store/r8578a0cfycmrxxp13xj6455ncy89pwr-source/flake.nix': true
  # fonts.fontconfig.enable = graphical;
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
