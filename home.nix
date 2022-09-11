{ pkgs, system, fonts, host, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  inherit (host) graphical username;

  graphicalLinux = isLinux && graphical;

  alacritty = import ./alacritty.nix {
    inherit (host) hostname;
    inherit pkgs;
  };
  git = import ./git.nix { inherit (host) work; };
  zsh = import ./zsh { inherit pkgs; };
  devPkgs = import ./dev.nix {
    inherit (host) system work;
    inherit pkgs;
  };

  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  customPackages = devPkgs ++ (with fonts.packages.${system}; [ sf-mono sf-pro ]);
  standardPackages = with pkgs; [
    neovim
    ripgrep
    powerline-fonts
  ];
  linuxPackages = with pkgs; (
    [ glibcLocales ] ++ (
      if graphical then [ nitrogen ] else [ ]
    )
  );

  platformPackages = if isLinux then linuxPackages else [ ];
  packages = standardPackages ++ customPackages ++ platformPackages;

  file =
    if isLinux then {
      i3-config = import ./i3 { inherit (host) hostname; };
    } else { };
in
{
  imports = [ ./modules/noisetorch.nix ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit file homeDirectory packages;
    inherit (host) username;
  };

  targets.genericLinux.enable = isLinux;

  fonts.fontconfig.enable = graphicalLinux;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    inherit alacritty git zsh;

    aria2.enable = true;
    jq.enable = true;

    keychain = {
      enable = host.keys != null;
      inherit (host) keys;
      enableZshIntegration = true;
    };

    gh.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services = {
    dunst.enable = graphicalLinux;
    noisetorch.enable = isLinux;
    redshift = {
      enable = graphicalLinux;
      latitude = 37.7749;
      longitude = -122.4194;
      temperature = {
        day = 5500;
        night = 3700;
      };
      tray = true;
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
