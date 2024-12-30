{ config, lib, ... }:

{
  imports = [ ./openwebui-module.nix ];
  options =
    let
      inherit (lib) mkOption types;
    in
    {
    denbeigh.services.bullshit = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      subdomain = mkOption {
        type = types.str;
        default = "bullshit";
      };

      port = mkOption {
        type = types.ints.u16;
        default = 7714;
      };
    };
  };

  config =
    let
      cfg = config.denbeigh.services.bullshit;

      inherit (lib) mkIf;
    in
    mkIf cfg.enable {
      age.secrets.openWebuiSecrets = {
        file = ../../secrets/openWebuiSecrets.age;
        mode = "400";
      };

      denbeigh.services.www.services = [{
        name = cfg.subdomain;
        enable = true;
        backend = "http://localhost:${toString cfg.port}";
        tailscale = true;
        ssl = true;
      }];

      services.open-webui-patched = {
        enable = true;

        inherit (cfg) port;
        environment = {
          ANONYMIZED_TELEMETRY = "False";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";

          # This is behind tailscale anyway.
          WEBUI_AUTH = "False";
        };

        # TODO: need to create secret here
        environmentFile = config.age.secrets.openWebuiSecrets.path;
      };
    };
}
