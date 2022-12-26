{ config, pkgs, lib, ... }:

let
  inherit (builtins) pathExists;
  inherit (lib) mkIf;
  inherit (config.denbeigh) hostname;

  configPath' = "./configs/${hostname}.nix";
  configPath = ./configs/${hostname}.nix;
in
{
  # TODO: Support this in configuration directly
  programs.autorandr = mkIf (pathExists configPath') ({
    enable = true;
  } // (import configPath));
}
