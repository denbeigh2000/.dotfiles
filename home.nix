{ pkgs, system, fonts, host, nixgl, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  inherit (host) username;

  alacritty = import ./alacritty.nix {
    inherit (host) hostname;
    inherit pkgs nixgl;
  };
  git = import ./git.nix { inherit (host) work; };
  zsh = import ./zsh/default.nix { inherit pkgs; };
  devPkgs = import ./dev.nix {
    inherit (host) system work;
    inherit pkgs;
  };

  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  standardPackages = with pkgs; [
    neovim
    ripgrep
    powerline-fonts
  ];
  customPackages = devPkgs ++ (with fonts.packages.${system}; [ sf-mono sf-pro ]);

  platformSpecific =
    (if isLinux
    then import ./linux/default.nix { inherit pkgs host; }
    else import ./darwin.nix { inherit pkgs; });
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit (host) username;
    inherit homeDirectory;
  };


  inherit (platformSpecific) services fonts;
  home.file = platformSpecific.files;

  targets.genericLinux.enable = isLinux;

  home.packages = (
    standardPackages ++
    customPackages ++
    platformSpecific.packages
  );

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
