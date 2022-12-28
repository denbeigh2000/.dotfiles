{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.denbeigh.services.nix-cache;
in
{
  imports = [ ./nginx/nix-cache.nix ];

  options.denbeigh.services.nix-cache = {
    enable = mkEnableOption "External Nix cache";

    domain = mkOption {
      type = types.str;
      default = "nix-cache.denbeigh.cloud";
      description = ''
        DNS record to direct to the Nix store.
      '';
    };

    keyFile = mkOption {
      type = types.path;
      description = ''
        Key file to authenticate requests from cache.
      '';
    };
  };

  config = mkIf cfg.enable {
    # NOTE: nix-serve in the system depends on this user being made. Define it
    # here, so we can specify a uid/gid and pre-generate keys with appropriate
    # permissions.

    users = {
      users."nix-serve" = {
        isSystemUser = true;
        uid = 1174;
      };

      groups."nix-serve".gid = 1174;
    };

    services.nix-serve = {
      enable = true;
      openFirewall = false;
      bindAddress = "127.0.0.1";
      secretKeyFile = cfg.keyFile;
    };
  };
}
