{ self, config, pkgs, lib, ... }:

let
  inherit (pkgs) nix;
  inherit (lib) mkOption types;
  cfg = config.denbeigh;
in

{
  imports = [
    self.inputs.agenix.nixosModules.default

    ../common/standard.nix
    ../common/variables.nix
    ./denbeigh.nix
    ./utils.nix
    ./graphical.nix
    ./use-nix-cache.nix

    # Disabled by default
    ./webcam.nix
  ];

  options.denbeigh.machine = {
    domain = mkOption {
      type = types.str;
      default = "sfo.denbeigh.cloud";
      description = ''
        Networking domain of the machine.
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

    time.timeZone = cfg.machine.location.timezone;
    services.chrony.enable = true;

    nix.settings = {
      # Remote-build key from personal machines
      trusted-public-keys = [ "remote-build:gmaC+UE4JxbR6wcMtuZ6WZF0nL1Jh2D3REY9zdwZFWg=" ];
    };
  };
}
