{ pkgs, host, ... }:

let
  inherit (pkgs) alacritty writeShellScriptBin;
  inherit (pkgs.denbeigh.fonts) sf-mono;
in
{
  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;

    users.root.initialHashedPassword = "$y$j9T$TK9zFbNlrHL9vroc.uBZC1$FRhAYk/Y4LY480eesYdxDIDOvttgzcmmaB0vF3ge.1C";
    users.${host.username}.initialHashedPassword = "$y$j9T$TK9zFbNlrHL9vroc.uBZC1$FRhAYk/Y4LY480eesYdxDIDOvttgzcmmaB0vF3ge.1C";
  };

  environment.systemPackages = with pkgs; [
    alacritty
    discord-canary
    firefox
    nix
    openssh
    scrot
    spotify
    vim
  ];

  console = {
    enable = true;
    font = sf-mono;
  };

  # NOTE: We explicitly don't use provide a config here, and defer to the
  # config populated by home-manager (see home-manager/modules/i3)
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
}