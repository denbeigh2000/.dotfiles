{ config, lib, ... }:

let
  inherit (lib) mkDefault mkIf mkOption types;

  cfg = config.denbeigh.nix-cache;
in
{
  # Ensures services.nix-cache options are defined
  # (but they're disabled by default)
  imports = [ ./nix-cache.nix ../common/use-nix-cache.nix ];

  config.denbeigh.nix-cache.enable = mkDefault (!config.denbeigh.services.nix-cache.enable);
}
