{
  nix.settings = {
    # Sometimes we may not be connected to Tailscale.
    connect-timeout = 3;
    extra-substituters = [ "https://nix-cache.denbeigh.cloud" ];
    trusted-substituters = [ "https://nix-cache.denbeigh.cloud" ];
    trusted-public-keys = [ "nix-cache.denbeigh.cloud-1:UeYPpNKlT8gTl7jRqOb+hawFbI5B20pPfSUbpWvSe9U=" ];
  };
}
