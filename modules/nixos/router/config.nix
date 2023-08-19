{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.denbeigh.services.router;
in
{
  options.denbeigh.services.router = {
    enable = mkEnableOption "Router service";

    interfaces = {
      lan = mkOption {
        type = types.str;
        description = "LAN network port to route with";
      };

      wan = mkOption {
        type = types.str;
        description = "WAN network port to route with";
      };
    };
  };

  config = {
    networking = {

      nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];

      interfaces = {
        ${cfg.interfaces.lan} = {
          useDHCP = false;
          ipv4.addresses = [{
            address = "10.69.1.1";
            prefixLength = 16;
          }];
        };

        ${cfg.interfaces.wan} = {
          useDHCP = true;
        };
      };

    };
  };
}
