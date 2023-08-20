{ pkgs, config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.denbeigh.machine) graphical;
in
{
  options.denbeigh.machine.graphical = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether this machine will be used interactively.
    '';
  };

  config = mkIf graphical {
    environment.systemPackages = with pkgs; [
      alacritty
      discord-canary
      spotify
      # maybe some other time
      # https://github.com/nixos/nixpkgs/issues/71689
      # firefox
    ];
  };
}
