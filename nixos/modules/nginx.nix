{
  age.secrets.digitalOceanKey = ../../secrets/digitalOceanAPIKey.age;

  services.nginx = {
    enable = true;
    # Drop all inbound connections by default
    virtualHosts."_".locations."/".return = 444;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
