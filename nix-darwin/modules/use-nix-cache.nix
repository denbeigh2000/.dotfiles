{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkOption types;

  cfg = config.denbeigh.nix-cache;
in
{
  options.denbeigh.nix-cache = {
    # TODO: Can we improve DRY between this and non-nix-darwin modules?
    enable = mkOption {
      type = types.bool;
      # Don't configure if this is the machine hosting the nix cache
      default = true;
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
      substituters = [ "https://cache.nixos.org" ];
      trusted-substituters = [ "https://cache.nixos.org" ];
      extra-trusted-substituters = [ cfg.url ];
      extra-trusted-public-keys = [ cfg.publicKey ];
    };
  };
}
