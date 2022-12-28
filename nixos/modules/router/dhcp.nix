{ config, ... }:

let
  inherit (config.denbeigh.services.router) interfaces;
in
{
  config = {
    # NOTE: This is usually created implicitly by dhcpd's systemd job, but we
    # need it to exist by the time this is being run.
    users = {
      users.dhcpd = {
        isSystemUser = true;
        description = "dhcpd service user";
        group = "${config.users.groups.dhcpd.name}";
      };
      groups.dhcpd = { };
    };

    age.secrets.dhcp-dns-update-key = {
      file = ../../../secrets/dhcpDnsAuthKey.age;
      owner = "${config.users.users.dhcpd.name}";
    };

    networking = {
      useDHCP = false;
    };

    services = {
      dhcpd4 = {
        enable = true;
        interfaces = [ interfaces.lan ];
        extraConfig =
          let
            dnsSecretPath = config.age.secrets.dhcp-dns-update-key.path;
            zoneSnippet = name: ''
              zone ${name}. {
                primary 127.0.0.1;
                key faye-dns-dhcp-key;
              }
            '';

          in
          ''
            option subnet-mask 255.255.0.0;
            option domain-name-servers 10.69.1.1;

            ddns-domainname "sfo.denbeigh.cloud.";
            ddns-rev-domainname "in-addr.arpa.";
            use-host-decl-names on;
            ddns-updates on;
            ddns-update-style standard;
            authoritative;

            include "${dnsSecretPath}";

            ${zoneSnippet "sfo.denbeigh.cloud"}

            ${zoneSnippet "1.69.10.in-addr.arpa"}

            subnet 10.69.1.0 netmask 255.255.255.0 {
              range 10.69.1.32 10.69.1.255;
              option broadcast-address 10.69.1.255;
              option routers 10.69.1.1;
              option domain-name "sfo.denbeigh.cloud";
              option domain-search "sfo.denbeigh.cloud";
              interface ${interfaces.lan};
            }
          '';
      };

      dhcpd6.enable = false;
    };
  };
}
