{
  services.nginx.virtualHosts."radarr" = {
    serverName = "radarr.denbeigh.cloud";
    locations."/".proxyPass = "http://localhost:7878";
  } // (import ./utils).withTailscale;
}


