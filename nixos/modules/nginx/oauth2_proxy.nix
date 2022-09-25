{
  services.nginx.virtualHosts."oauthproxy" = {
    serverName = "auth.bruce.denbeigh.cloud";
    enableACME = true;
    locations."/".proxyPass = "http://localhost:4180";
  };
}
