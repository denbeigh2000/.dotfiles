{ pkgs, neovim, host, nixgl, rnix-lsp, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  inherit (host) username;

  alacritty = import ./alacritty.nix { inherit pkgs nixgl; };
  git = import ./git.nix { inherit (host) work; };
  zsh = import ./zsh/default.nix { inherit pkgs; };

  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  platformSpecific =
    (if isLinux
    then import ./linux.nix { inherit pkgs host; }
    else import ./darwin.nix { inherit pkgs; });
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit (host) username;
    inherit homeDirectory;
  };

  home.file = platformSpecific.files;

  targets.genericLinux.enable = isLinux;

  home.packages = with pkgs; [
    ripgrep
  ] ++ [ neovim rnix-lsp ] ++ platformSpecific.packages;

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
