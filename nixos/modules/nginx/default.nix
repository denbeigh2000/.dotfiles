{ config, ... }:

{
  age.secrets.digitalOceanKey.file = ../../../secrets/digitalOceanAPIKey.age;

  services.nginx = {
    enable = true;
    # Drop all inbound connections by default
    virtualHosts."misc" = {
      serverName = "_";
      locations."/".return = "444";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      credentialsFile = config.age.secrets.digitalOceanKey.path;
      dnsProvider = "digitalocean";
      email = "denbeigh+letsencrypt@denbeighstevens.com";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
