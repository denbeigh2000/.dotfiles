{ self, pkgs, lib, config, ... }:

let
  inherit (lib) mkDefault;

  cfg = config.denbeigh.nix-cache;
in
{
  imports = [
    self.inputs.nix-upload-daemon.darwinModules.default
    ../common/use-nix-cache.nix
  ];

  config.denbeigh.nix-cache.enable = mkDefault true;
}
