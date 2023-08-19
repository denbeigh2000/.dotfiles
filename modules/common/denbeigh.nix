{ config, lib, ... }:

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

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${cfg.user.username} = {
      imports = [ ../home-manager ];

      denbeigh = {
        inherit (cfg.machine) graphical hostname work;
        inherit (cfg.user) username keys;
      };
    };
  };
}
