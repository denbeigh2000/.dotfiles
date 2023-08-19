{
  services.nginx.virtualHosts."sonarr" = {
    serverName = "sonarr.denbeigh.cloud";
    locations."/".proxyPass = "http://localhost:8989";
  } // (import ./utils).withTailscale;
}

