{ config, ... }:

let
  httpPort = config.services.keycloak.settings.http-port;
in

{
  services.nginx.virtualHosts."keycloak" = {
    serverName = "keycloak.denbeigh.cloud";
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${toString httpPort}";
  };
}
