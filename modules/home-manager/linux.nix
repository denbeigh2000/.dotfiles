{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
in

{
  imports = [ ./noisetorch.nix ./i3 ./autorandr ];

  options.denbeigh.location = lib.options.location;

  config = mkIf isLinux (
    let
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
        noisetorch.enable = graphical && isLinux;
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
