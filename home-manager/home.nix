{ pkgs
, lib
, system
, fonts
, host
, agenix
, denbeigh-devtools
, nixgl
, ...
}:

let
  inherit (host) graphical system username;
  # NOTE: Using stdenv.hostPlatform here causes an import cycle
  inherit (lib.systems.elaborate system) isLinux isDarwin;

  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [ ./modules/dev.nix ./modules/git.nix ./modules/zsh ]
    ++ (if isLinux then [ ./modules/linux.nix ] else [ ])
    ++ (if graphical then [ ./modules/graphical.nix ] else [ ]);

  nixpkgs.overlays = [
    agenix.overlay
    denbeigh-devtools.overlays.default
    fonts.overlays.default
    nixgl.overlay
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit homeDirectory;
    inherit (host) username;

    packages = with pkgs; [ ripgrep ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    aria2.enable = true;
    fzf.enable = true;
    gh.enable = true;
    jq.enable = true;
    tmux.enable = true;

    keychain = {
      enable = host ? keys;
      keys = host.keys or null;
    };
  };
}
