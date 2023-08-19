{ config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;

  cfg = config.denbeigh.nix-cache;
in
{
  # Ensures services.nix-cache options are defined
  # (but they're disabled by default)
  imports = [ ./nix-cache.nix ../common/use-nix-cache.nix ];

  options.denbeigh.nix-cache.enable.default =
    !config.denbeigh.services.nix-cache.enable;
}
