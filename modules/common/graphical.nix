{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.denbeigh.machine;
in
{
  options.denbeigh.machine.graphical = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether this machine will be used interactively.
    '';
  };

  config = mkIf cfg.graphical {
    # NOTE: Not compatible with home-manager
    environment.systemPackages = with pkgs; [
      alacritty
      discord-canary
      spotify
      mpv
      # Maybe some other time
      # https://github.com/NixOS/nixpkgs/issues/71689
      # firefox
    ];
  };
}
