{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.denbeigh = {
    machine = {
      hostname = mkOption {
        type = types.str;
        description = ''
          The hostname of this machine.
        '';
      };

      graphical = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether this machine will be used interactively.
        '';
      };

      work = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether this machine will be used for work purposes.
        '';
      };
    };
  };
}
