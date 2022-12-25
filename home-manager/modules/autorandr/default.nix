{ pkgs, lib, host, ... }:

let
  inherit (builtins) pathExists;
  inherit (lib) mkIf;

  configPath' = ./configs/${host.hostname}.nix;
  configPath = builtins.trace configPath' configPath';
in
{
  programs.autorandr = mkIf (pathExists configPath) ({
    enable = true;
  } // (import configPath));
}
