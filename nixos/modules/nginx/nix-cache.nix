{ config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.services.nix-serve) port;
  cfg = config.denbeigh.services.nix-cache;

  tailscaleConfig =
    if cfg.tailscaleOnly
    then (import ./utils).withTailscale
    else { };
in
{

  options.denbeigh.services.nix-cache = {
    tailscaleOnly = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If disabled, serves to the public internet.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."nix-cache" = {
      serverName = cfg.domain;
      locations."/".proxyPass = "http://localhost:${port}";
    } // tailscaleConfig;
  };
}
