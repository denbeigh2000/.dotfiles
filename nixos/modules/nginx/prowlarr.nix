{
  services.nginx.virtualHosts."prowlarr" = {
    serverName = "prowlarr.denbeigh.cloud";
    locations."/".proxyPass = "http://localhost:9696";
  } // (import ./utils).withTailscale;
}


