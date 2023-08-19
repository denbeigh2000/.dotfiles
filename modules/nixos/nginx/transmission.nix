{
  services.nginx.virtualHosts."transmission" = {
    serverName = "transmission.denbeigh.cloud";
    locations."/".proxyPass = "http://localhost:9091";
  } // (import ./utils).withTailscale;
}
