{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.denbeigh.services.nix-cache;
in
{
  imports = [ ./nginx ];

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
      # Needed to grant any access over SSH at all
      isNormalUser = true;
      group = "nix-copy-receiver";
      openssh.authorizedKeys.keys = [
        # SSH Key to permit remote build uploads to service user
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn3tzQJW1Fwt3n5xSK+V6MhS7ULddEW0mTNcrigHbp0"
      ];
    };
    users.groups.nix-copy-receiver = { };

    denbeigh.services.www.nix-cache.enable = true;
    services.harmonia = {
      enable = true;
      signKeyPaths = [ cfg.keyFile ];
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
