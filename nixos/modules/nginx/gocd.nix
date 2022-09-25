{
  services.nginx.virtualHosts."gocd" = {
    serverName = "ci.denbeigh.cloud";
    # addSSL = true;
    # enableACME = true;
    locations."/".proxyPass = "http://localhost:8154";
  };
}
