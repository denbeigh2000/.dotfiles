{ config, pkgs, ... }:

let
  inherit (config.denbeigh.services.router) interfaces;

  # TODO: Finish configuring dhcp dynamic host registration
  # https://archyslife.blogspot.com/2018/02/dynamic-dns-with-bind-and-isc-dhcp.html
  # https://www.talk-about-it.ca/setup-bind9-with-isc-dhcp-server-dynamic-host-registration
in
{
  age.secrets.dns-dhcp-update-key = {
    file = ../../../../secrets/dhcpDnsAuthKey.age;
    owner = "${config.users.users.named.name}";
  };

  services.bind = {
    enable = true;
    listenOn = [ "10.69.1.1" "127.0.0.1" ];
    cacheNetworks = [ "127.0.0.0/24" "10.69.0.0/16" ];
    extraConfig = ''
      include "${config.age.secrets.dns-dhcp-update-key.path}";
    '';
    zones =
      let
        dhcpUpdateSnippet = (zone: ''
          allow-update { key faye-dns-dhcp-key; };
          journal "/var/run/named/${zone}.zone.jnl";
        '');

        buildZone = (name: {
          ${name} = {
            master = true;
            file = ./${name}.zone;
            extraConfig = ''
              ${(dhcpUpdateSnippet "name")}
            '';
          };
        });
      in
      (buildZone "sfo.denbeigh.cloud") // (buildZone "1.69.10.in-addr.arpa");
  };
}
