{ config, pkgs, lib, ... }:

let
  inherit (pkgs) alacritty writeShellScriptBin;
  inherit (pkgs.denbeigh.fonts) sf-mono;
  inherit (lib) mkIf;
  inherit (config.denbeigh.user) username;
  inherit (config.denbeigh.machine) graphical;

in
{
  imports = [
    ../common/graphical.nix
  ];

  config = mkIf graphical {
    nixpkgs.config.allowUnfree = true;
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

    nixpkgs.config.pulseaudio = true;
    hardware.pulseaudio = {
      enable = true;
      extraConfig = "load-module module-combine-sink";
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };

    # NOTE: We explicitly don't use provide a config here, and defer to the
    # config populated by home-manager (see ../home-manager/i3)
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
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
