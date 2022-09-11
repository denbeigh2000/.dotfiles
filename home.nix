{ pkgs, system, fonts, host, denbeigh-devtools, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  inherit (host) graphical username;

  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [ ./modules/dev.nix ./modules/git.nix ./modules/zsh ]
  ++ (if isLinux then [ ./modules/linux.nix ] else [ ])
  ++ (if graphical then [ ./modules/graphical.nix ] else [ ]);

  nixpkgs.overlays = [
    denbeigh-devtools.overlay
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit homeDirectory;
    inherit (host) username;

    packages = with pkgs; [ ripgrep ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    aria2.enable = true;
    jq.enable = true;

    keychain = {
      enable = host.keys != null;
      inherit (host) keys;
    };

    gh.enable = true;

    fzf.enable = true;
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
