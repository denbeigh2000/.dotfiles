{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.denbeigh.ahoy;

  groupName = "media";
  serviceConfig = {
    enable = true;
    group = groupName;
  };
in
{
  imports = [
    ./nginx
    ./transmission.nix
    ./wireguard.nix
  ];

  options.denbeigh.ahoy = {
    enable = mkEnableOption "ahoy";
  };

  config = mkIf cfg.enable {
    users.groups."${groupName}".gid = 94;

    denbeigh = {
      # wireguard = {
      #   enable = false;
      #   users = [ "transmission" "jackett" ];
      # };

      # Be sure we have access to web-facing services
      services.www = {
        enable = true;
        jackett.enable = true;
        jellyfin.enable = true;
        prowlarr.enable = true;
        radarr.enable = true;
        sonarr.enable = true;
        transmission.enable = true;
      };
    };

    services = {
      jellyfin.enable = true;
      # TODO: Create a PR that adds group/package/etc. to this config
      prowlarr.enable = true;
      sonarr = serviceConfig;
      radarr = serviceConfig;
      jackett = serviceConfig;
      transmission = serviceConfig;
    };
  };
}
