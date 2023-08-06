{ config, pkgs, lib, agenix, ... }:

let
  cfg = config.denbeigh;
in
{
  imports = [
    ./base.nix
    ./use-nix-cache.nix
    ./home.nix
    ./system-options.nix
    ./upload-daemon.nix
  ];

  config = {
    nixpkgs = {
      config.allowUnfree = true;
    };

    environment.systemPackages = with pkgs; [
      # Maybe some other time
      # https://github.com/NixOS/nixpkgs/issues/71689
      # firefox

      alacritty
      discord-canary
      git
      spotify
    ];

    services.nix-daemon.enable = true;
    programs.zsh = {
      enable = true;
      promptInit = "";
    };

    users.users.${cfg.user.username} = {
      name = cfg.user.username;
      home = "/Users/${cfg.user.username}";
    };
  };
}
