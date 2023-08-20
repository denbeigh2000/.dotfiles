{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.denbeigh.machine;
in
{
  # NOTE: We split this into a separate import because Nix has an infinite
  # recursion if we use pkgs in graphical-inner
  imports = [ ./graphical-inner.nix ];
  config = mkIf cfg.graphical {
    environment.systemPackages = with pkgs; [
      alacritty
      discord-canary
      spotify
      # Maybe some other time
      # https://github.com/NixOS/nixpkgs/issues/71689
      # firefox
    ];
  };
}
