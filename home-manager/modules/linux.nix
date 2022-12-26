{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption types;
in

{
  imports = [ ./noisetorch.nix ./i3 ./autorandr ];

  options.denbeigh.location = mkOption {
    type = types.nullOr (types.submodule {
      options = {
        latitude = mkOption {
          type = types.float;
        };

        longitude = mkOption {
          type = types.float;
        };
      };
    });
    default = {};
    description = ''
      Coordinates of the machine.
      Currently only used for redshift.

      redshift will be disabled on graphical machines where this is not
      provided.
    '';
  };

  config =
    let
      inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
      inherit (config.denbeigh) graphical isNixOS location;
      enableRedshift = graphical && isLinux && location != null;
      graphicalPackages = with pkgs; [ nitrogen ];

      coords = if location != null then location else { };
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
        dunst.enable = graphical;
        noisetorch.enable = graphical;
        redshift = {
          enable = enableRedshift;
          temperature = {
            day = 5500;
            night = 3700;
          };
          tray = true;
        } // coords;
      };
    };
}
