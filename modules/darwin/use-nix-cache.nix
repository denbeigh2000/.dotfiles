{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkOption types;

  cfg = config.denbeigh.nix-cache;
in
{
  imports = [ ../common/use-nix-cache.nix ];
  options.denbeigh.nix-cache.enable.default = true;
}
