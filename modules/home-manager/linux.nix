{ self, config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkDefault mkOption types;
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
in

{
  imports = [ ./noisetorch.nix ./i3 ./autorandr ];

  config = mkIf isLinux (
    let
      inherit (config.denbeigh) graphical isNixOS location;

      hasCoordinates = (
        location != null &&
        location ? coordinates
      );
      enableRedshift = graphical && isLinux && hasCoordinates;
      graphicalPackages = with pkgs; [ nitrogen ];

      coords = if hasCoordinates then location.coordinates else { };
    in
    {
      home = {
        packages = with pkgs; [ glibcLocales ]
          ++ (if graphical then graphicalPackages else [ ]);
      };

      # TODO: Check if necessary on NixOS?
      fonts.fontconfig.enable = true;
      targets.genericLinux.enable = isLinux && !isNixOS;

      services = {
        dunst.enable = mkDefault graphical;
        redshift = {
          enable = enableRedshift;
          temperature = {
            day = 5500;
            night = 3700;
          };
          tray = true;
        } // coords;
      };
    }
  );
}
