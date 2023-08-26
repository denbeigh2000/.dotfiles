{ self
, config
, pkgs
, lib
, ...
}:


let
  inherit (lib) mkOption types;
  inherit (config.denbeigh) username;
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin isLinux;

  htopFields = with config.lib.htop.fields;
    if isDarwin
    then [ PID USER PRIORITY M_SIZE M_RESIDENT PERCENT_CPU PERCENT_MEM TIME COMM ]
    else [ PID USER PRIORITY NICE M_SIZE M_RESIDENT STATE PERCENT_CPU PERCENT_MEM IO_RATE TIME COMM ];
in
{
  imports = with self.homeManagerModules; [
    dev
    git
    htop
    zsh
    linux
    graphical
    scripts
    use-nix-cache
    webcam
  ];

  options.denbeigh = {
    username = mkOption {
      type = types.str;
      default = "denbeigh";
      description = ''
        Username of the user to provision on the system.
      '';
    };

    hostname = mkOption {
      type = types.str;
      description = ''
        The hostname of the machine being provisioned.
      '';
    };

    shell = mkOption {
      type = types.package;
      default = pkgs.zsh;
      description = ''
        Shell to use for the environment.
      '';
    };

    # TODO: Rename this?
    keys = mkOption {
      type = types.listOf types.str;
      default = [ "id_ed25519" ];
      description = ''
        The SSH key paths to expect to use.
      '';
    };

    graphical = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this machine will be used interactively.
      '';
    };

    location = self.lib.options.location;

    # TODO: Make naming consistent
    isNixOS = mkOption {
      type = types.bool;
      description = ''
        Whether the machine being provisioned is running NixOS.
      '';
    };

    work = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this machine will be used for "work" purposes.
      '';
    };
  };

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      inherit username;
      homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

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
      jq.enable = !config.denbeigh.work;
      tmux.enable = true;

      keychain = {
        enable = (builtins.length config.denbeigh.keys) > 0;
        inherit (config.denbeigh) keys;
      };
    };
  };
}

