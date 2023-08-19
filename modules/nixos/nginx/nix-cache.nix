{ config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;
  cfg = config.denbeigh.services.nix-cache;

  tailscaleConfig =
    if cfg.tailscaleOnly
    then (import ./utils).withTailscale
    else { };
in
{

  options.denbeigh.services.nix-cache = {
    domain = mkOption {
      type = types.str;
      default = "nix-cache.denbeigh.cloud";
      description = ''
        DNS record to direct to the Nix store.
      '';
    };

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
      locations."/".proxyPass = "http://localhost:5000";
    } // tailscaleConfig;
  };
}
