{
  imports = [
    ./nginx/jellyfin.nix
    ./nginx/transmission.nix
    ./nginx/jackett.nix
    ./nginx/prowlarr.nix
    ./nginx/sonarr.nix
    ./nginx/radarr.nix
  ];

  services = {
    transmission.enable = true;
    jellyfin.enable = true;
    prowlarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
    jackett.enable = true;
  };
}
