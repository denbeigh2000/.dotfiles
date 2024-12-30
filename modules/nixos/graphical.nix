{ config, pkgs, lib, ... }:

let
  inherit (pkgs) alacritty writeShellScriptBin;
  inherit (lib) mkIf;
  inherit (config.denbeigh.user) username;
  inherit (config.denbeigh.machine) graphical;

in
{
  imports = [
    ../common/denbeigh.nix
    ../common/graphical.nix
    ../common/variables.nix
  ];

  config = mkIf graphical {
    users = {
      mutableUsers = true;

      users = {
        root.initialHashedPassword = "$y$j9T$TK9zFbNlrHL9vroc.uBZC1$FRhAYk/Y4LY480eesYdxDIDOvttgzcmmaB0vF3ge.1C";
        ${username} = {
          initialHashedPassword = "$y$j9T$TK9zFbNlrHL9vroc.uBZC1$FRhAYk/Y4LY480eesYdxDIDOvttgzcmmaB0vF3ge.1C";
          extraGroups = [ "audio" ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      firefox
      openssh
      pavucontrol
      scrot
    ];

    console.enable = true;

    services.displayManager.sddm.enable = true;
    services.xserver = {
      enable = true;
      # NOTE: We explicitly don't use provide a config here, and defer to the
      # config populated by home-manager (see ../home-manager/i3)
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ dmenu i3lock ];
        extraSessionCommands = ''
          export TERMINAL="${alacritty}/bin/alacritty"
        '';
      };
    };

  };
}
