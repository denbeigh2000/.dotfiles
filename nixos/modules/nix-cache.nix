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
    nix.settings = {
      # Remote-build key from personal machines
      trusted-public-keys = [ "remote-build:gmaC+UE4JxbR6wcMtuZ6WZF0nL1Jh2D3REY9zdwZFWg=" ];
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
