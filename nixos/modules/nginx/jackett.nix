{
  services.nginx.virtualHosts."jackett" = {
    serverName = "jackett.denbeigh.cloud";
    locations."/".proxyPass = "http://localhost:9117";
  } // (import ./utils).withTailscale;
}


