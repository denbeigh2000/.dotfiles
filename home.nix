{ config, pkgs, ... }:

let
  inherit (pkgs.stdenv) hostPlatform;

  hosts = {
    martha = {
      work = false;
      graphical = "single";
      username = "denbeigh";
      home = "/home/denbeigh";
      keys = ["id_ed25519"];
    };
    mutant = {
      work = true;
      graphical = "single";
      username = "denbeighstevens";
      home = "/Users/denbeighstevens";
      keys = ["id_ed25519"];
    };
  };


  hostname = (builtins.getEnv "HOSTNAME");
  host = hosts."${hostname}";

  alacritty = import ./alacritty.nix { inherit pkgs; };
  git = import ./git.nix { inherit (host) work; };
  zsh = import ./zsh/default.nix { inherit pkgs; };

  platformSpecific = (if hostPlatform.isLinux
                      then import ./linux.nix { inherit pkgs host; }
                      else import ./darwin.nix { inherit pkgs; });
in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = host.username;
    home.homeDirectory = host.home;

    home.file = platformSpecific.files;

    targets.genericLinux.enable = hostPlatform.isLinux;

    home.packages = with pkgs; [
      ripgrep
      neovim
    ] ++ platformSpecific.packages;

    services = platformSpecific.services;

    programs = {
      # Let Home Manager install and manage itself.
      home-manager.enable = true;

      inherit alacritty git zsh;

      aria2.enable = true;
      jq.enable = true;

      keychain = {
        enable = true;
        inherit (host) keys;
        enableZshIntegration = true;
      };

      gh.enable = true;

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.05";
  }

