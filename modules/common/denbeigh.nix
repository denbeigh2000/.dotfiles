{ self, config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.denbeigh;
in
{
  options.denbeigh = {
    user = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Install extended user dotfiles.
        '';
      };

      username = mkOption {
        type = types.str;
        default = "denbeigh";
        description = ''
          Username of the user to provision on the system.
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
        default = [ ];
        description = ''
          The SSH key paths to expect to use.
        '';
      };
    };

    machine.isNixOS = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If this machine is running NixOS.
      '';
    };
  };

  config = {
    nixpkgs.overlays = [
      self.inputs.agenix.overlays.default
      self.inputs.nixgl.overlays.default
      self.inputs.denbeigh-neovim.overlays.default
      self.inputs.denbeigh-devtools.overlays.default
    ];

    home-manager = mkIf cfg.user.enable {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${cfg.user.username} = {
        imports = [ self.homeManagerModules.standard ];

        denbeigh = {
          inherit (cfg.machine) graphical hostname work isNixOS;
          inherit (cfg.user) username keys;
        };
      };
    };
  };
}
