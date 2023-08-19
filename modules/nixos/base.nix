{ lib, ... }:

let
  inherit (lib) mkOption types;

in

{
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

    location = mkOption {
      type = types.submodule {
        options = {
          timezone = mkOption {
            type = types.str;
            default = "UTC";
            description = ''
              Timezone of the machine
            '';
          };

          coordinates = mkOption {
            type = types.nullOr types.submodule {
              options = {
                latitude = mkOption {
                  type = types.float;
                };

                longitude = mkOption {
                  type = types.float;
                };
              };
            };
            default = null;
            description = ''
              Coordinates of the machine.
              Currently only used for redshift.

              redshift will be disabled on graphical machines where this is not
              provided.
            '';
          };
        };
      };
    };
  };
}
