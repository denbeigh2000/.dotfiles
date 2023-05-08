{ config, pkgs, lib, ... }:

let
  cfg = config.denbeigh;
in
{
  imports = [
    ./base.nix
    ./use-nix-cache.nix
    ./home.nix
    ./system-options.nix
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
