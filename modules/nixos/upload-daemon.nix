{ pkgs, lib, config, nix-upload-daemon, ... }:

let
  inherit (config.denbeigh) machine nix-cache;
  cfg = config.denbeigh.nix-upload-daemon;
in
{
  imports = [
    nix-upload-daemon.nixosModules.default
    ../common/upload-daemon.nix
  ];

  options = {
    denbeigh.nix-upload-daemon.enable = lib.mkOption {
      type = lib.types.bool;
      default = !(machine.work || nix-cache.enable);
    };
  };

  config.assertions = [
    {
      assertion = !(nix-cache.enable && cfg.enable);
      message = "The nix-cache shouldn't upload, because it serves from its' local store anyway.";
    }
  ];
}
