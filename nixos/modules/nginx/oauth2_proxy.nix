{
  services.nginx.virtualHosts."oauthproxy" = {
    serverName = "auth.bruce.denbeigh.cloud";
    # addSSL = true;
    # enableACME = true;
    locations."/".proxyPass = "http://localhost:4180";
  };
}
