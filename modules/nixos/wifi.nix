{ lib, config, ... }:

let
  cfg = config.denbeigh.wifi;

  networks = {
    "Sanctum".pskRaw = "ext:home_primary_psk";
  };


  pluckNetworks = ssids:
    builtins.listToAttrs (
      lib.lists.imap0
        (index: ssid: {
          name = ssid;
          value = networks.${ssid} // {
            priority = 3 * -index;
          };
        })
        ssids
    );

in
{
  options.denbeigh.wifi = {
    enable = lib.mkEnableOption "wifi configuration";

    networks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "SSIDs to use, with most desired first";
    };

    interfaces = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      description = ''
        Devices to use for wifi connection. If unset, NixOS default will
        be used (currently all wirless devices)
      '';
      default = null;
    };
  };

  config =
    lib.mkIf cfg.enable {
      age.secrets.wpaSupplicantSecrets = {
        file = ../../secrets/wpaSupplicantSecrets.age;
      };

      networking.wireless = {
        enable = true;
        interfaces = lib.mkIf (cfg.interfaces != null) cfg.interfaces;
        secretsFile = config.age.secrets.wpaSupplicantSecrets.path;
        networks = pluckNetworks cfg.networks;
        allowAuxiliaryImperativeNetworks = true;
        extraConfig = ''
          country=US
        '';
      };
    };
}
