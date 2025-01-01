{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.denbeigh.nix-cache;
in

{
  options.denbeigh.nix-cache = {
    enable = mkOption {
      type = types.bool;
      # This is configured at the system level on NixOS machines.
      default = !config.denbeigh.isNixOS;
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

    config = mkIf cfg.enable {
      nix.settings = {
        # Sometimes we may not be connected to Tailscale.
        connect-timeout = 3;
        # For some reason, we don't make use of our own resolver by default if we
        # only make use of extra-substituters here
        # (cache.nixos.org is added to substituters and trusted-substituters by default)
        substituters = [ cfg.url ];
        trusted-substituters = [ cfg.url ];
        trusted-public-keys = [ cfg.publicKey ];
      };
    };
  };
}
