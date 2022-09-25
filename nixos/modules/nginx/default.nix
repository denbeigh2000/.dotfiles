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

  services.oauth2_proxy.skipAuthRegexes = [
    # TODO: WTF is wrong with these regexes, and why do done of them work?
    # Maybe TVL was right in writing their own module...
    ".*oauth/.*"
    ''.*well-known.*''
    # ''.*acme.*''
    # ''.*''
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
