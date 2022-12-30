{ config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;

  cfg = config.denbeigh.nix-cache;
in
{
  # NOTE: Subtly different from denbeigh.services.nix-cache
  options.denbeigh.nix-cache = {
    enable = mkOption {
      type = types.bool;
      # Don't configure if this is the machine hosting the nix cache
      default = !config.denbeigh.services.nix-cache.enable;
      description = ''
        Whether to enable personal nix cache.
      '';
    };

    url = mkOption {
      type = types.str;
      default = "https://nix-cache.denbeigh.cloud";
      description = ''
        URL of our nix cache.
      '';
    };

    publicKey = mkOption {
      type = types.str;
      default = "nix-cache.denbeigh.cloud-1:UeYPpNKlT8gTl7jRqOb+hawFbI5B20pPfSUbpWvSe9U=";
      description = ''
        Public key of our nix cache for trusting purposes.
      '';
    };
  };

  config = mkIf cfg.enable {
    nix.settings = {
      # Sometimes we may not be connected to Tailscale.
      connect-timeout = 3;
      # For some reason, we don't make use of our own resolver by default if we
      # only make use of extra-substituters here
      substituters = [ cfg.url "https://cache.nixos.org" ];
      trusted-substituters = [ cfg.url ];
      trusted-public-keys = [ cfg.publicKey ];
    };
  };
}
