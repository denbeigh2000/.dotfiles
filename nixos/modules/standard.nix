{ config, pkgs, lib, ... }:

let
  inherit (pkgs) nix;
  inherit (lib) mkOption types;
  cfg = config.denbeigh;
in

{
  imports = [
    ./denbeigh.nix
    ./flakes.nix
    ./utils.nix
    ./graphical.nix
    ./use-nix-cache.nix

    # Disabled by default
    ./webcam.nix
  ];

  options.denbeigh.machine = {
    hostname = mkOption {
      type = types.str;
      description = ''
        Hostname of the machine.
      '';
    };

    domain = mkOption {
      type = types.str;
      default = "sfo.denbeigh.cloud";
      description = ''
        Networking domain of the machine.
      '';
    };

    graphical = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this machine will be used interactively.
      '';
    };

    work = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this machine will be used for "work" purposes.
      '';
    };

    location =
      let
        defaultTimezone = "UTC";

        coordinatesShape = {
          options = {
            latitude = mkOption {
              type = types.float;
            };

            longitude = mkOption {
              type = types.float;
            };

            description = ''
              Coordinates of the machine.
              Currently only used for redshift.

              redshift will be disabled on graphical machines where this is not
              provided.
            '';
          };
        };
      in
      mkOption {
        type = types.submodule {
          options = {
            timezone = mkOption {
              default = defaultTimezone;
              type = types.str;
            };
            coordinates = mkOption {
              type = types.nullOr (types.submodule coordinatesShape);
              default = null;
            };
          };
        };
        default = { timezone = defaultTimezone; };
      };
  };

  config = {
    networking = {
      hostName = cfg.machine.hostname;
      inherit (cfg.machine) domain;
    };

    environment.systemPackages = [ nix ];
    programs.zsh.enable = true;
    time.timeZone = cfg.machine.location.timezone;
    services.chrony.enable = true;
  };
}
