{ config, lib, ... }:

let
  inherit (builtins) listToAttrs map;
  inherit (lib) mkEnableOption mkIf mkOption recursiveUpdate types;

  cfg = config.denbeigh.services.www;
in
{

  imports = [
    ./jackett.nix
    ./jellyfin.nix
    ./nix-cache.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./transmission.nix
  ];

  options.denbeigh.services.www = {
    enable = mkEnableOption "Web server";

    baseDomain = mkOption {
      type = types.str;
      default = "denbeigh.cloud";
      description = ''
        Base domain name to use for exposed services
      '';
    };

    services = mkOption {
      description = ''
        Services to expose through web server.
      '';
      default = [ ];
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = ''
              Name of the service to expose (used in domain name).
            '';
          };

          backend = mkOption {
            type = types.str;
            description = ''
              HTTP destination of the backend to serve.
            '';
          };

          tailscale = mkEnableOption "tailscale proxy serving";
          ssl = mkOption {
            default = true;
            type = types.bool;
            description = ''
              Whether to enable SSL serving.
            '';
          };

          extraConfig = mkOption {
            default = { };
            type = types.attrs;
            description = ''
              Additional config to pass to the nginx virtual host verbatim.
            '';
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    age.secrets.digitalOceanKey.file = ../../../secrets/digitalOceanAPIKey.age;

    security.acme = {
      acceptTerms = true;
      defaults = {
        credentialsFile = config.age.secrets.digitalOceanKey.path;
        dnsProvider = "digitalocean";
        email = "denbeigh+letsencrypt@denbeighstevens.com";
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nginx = {
      enable = true;
      # Drop all inbound connections by default
      virtualHosts = {
        "misc" = {
          serverName = "_";
          locations."/".return = "444";
        };
      } // (
        # Build our dynamic list of hosts from configuration
        let
          # TODO: Bind this to the interface name instead somehow?
          tailscaleIP = "100.110.24.108";

          buildService = service:
            let
              enableSSL = service.ssl || service.tailscale;

              ssl = mkIf enableSSL {
                enableACME = true;
                forceSSL = true;
                # Must be null to enforce using DNS challenge default
                acmeRoot = null;
              };

              tailscale = mkIf service.tailscale (import ./tailscale.nix tailscaleIP);

              config = recursiveUpdate service.extraConfig {
                serverName = "${service.name}.${cfg.baseDomain}";
                locations."/".proxyPass = service.backend;
              };
            in
            {
              inherit (service) name;
              value = config // ssl // tailscale;
            };
        in
        listToAttrs (map buildService cfg.services)
      );
    };
  };
}
