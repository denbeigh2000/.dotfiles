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
  };
}
