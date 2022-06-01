{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "denbeigh";
  home.homeDirectory = "/home/denbeigh";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Denbeigh Stevens";
    userEmail = "denbeigh@denbeighstevens.com";
    extraConfig = {
      help.autocorrect = -1;
      merge.ff = "only";
      fetch.prune = true;
    };
  };

  programs.gh.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "rust"];
      theme = "steeef";
    };
    initExtra = (builtins.readFile ./zsh/zshrc);
  };
}

