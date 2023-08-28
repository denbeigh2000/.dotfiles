{ pkgs, lib, ... }:

let
  inherit (lib) mkOption types;
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
in
{
  options.denbeigh.machine = {
    hostname = mkOption {
      type = types.str;
      description = ''
        Hostname of the machine.
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
}
