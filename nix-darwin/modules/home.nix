{ config, lib, pkgs, home-manager, agenix, denbeigh-devtools, fonts, ... }@inputs:

let
  inherit (lib) mkOption types;

  cfg = config.denbeigh;
in
{
  options.denbeigh.user = {
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

  config = {
    nixpkgs.overlays = [
      agenix.overlay
      denbeigh-devtools.overlays.default
      fonts.overlays.default
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit (inputs) agenix denbeigh-devtools fonts nixgl;
      };

      users.${cfg.user.username} = {
        denbeigh = {
          inherit (cfg.machine) graphical hostname work;
          inherit (cfg.user) username keys;
        };

        imports = [
          ../../home-manager/modules/default.nix
        ];
      };
    };
  };
}
