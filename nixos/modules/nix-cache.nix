{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.denbeigh.services.nix-cache;
in
{
  imports = [ ./nginx/nix-cache.nix ];

  # NOTE: Subtly different from denbeigh.nix-cache (adds .services)
  options.denbeigh.services.nix-cache = {
    enable = mkEnableOption "External Nix cache";

    keyFile = mkOption {
      type = types.path;
      description = ''
        Key file to authenticate requests from cache.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.nix-copy-receiver = {
      openssh.authorizedKeys.keys = [
        # SSH Key to permit remote build uploads to service user
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn3tzQJW1Fwt3n5xSK+V6MhS7ULddEW0mTNcrigHbp0"
      ];
    };

    services.harmonia = {
      enable = true;
      signKeyPath = cfg.keyFile;
      settings = {
        # Nix cache priority
        priority = 50;
        # Concurrent workers
        workers = 4;
        # Max. open connections
        max_connection_rate = 256;
      };
    };
  };
}
