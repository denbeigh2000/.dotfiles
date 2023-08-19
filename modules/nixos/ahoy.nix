{ config, pkgs, ... }:

{
  imports = [
    ./nginx/jackett.nix
    ./nginx/jellyfin.nix
    ./nginx/prowlarr.nix
    ./nginx/radarr.nix
    ./nginx/sonarr.nix
    ./transmission.nix
    ./wireguard.nix
  ];

  config =
    let
      groupName = "media";
      serviceConfig = {
        enable = true;
        group = groupName;
      };
    in
    {
      users.groups."${groupName}".gid = 94;

      denbeigh = {
        transmission = serviceConfig;
        wireguard = {
          enable = true;
          users = [ "transmission" "jackett" ];
        };
      };

      services = {
        jellyfin.enable = true;
        # TODO: Create a PR that adds group/package/etc. to this config
        prowlarr.enable = true;
        sonarr = serviceConfig;
        radarr = serviceConfig;
        jackett = serviceConfig;
      };
    };
}
