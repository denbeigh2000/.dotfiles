{ config, pkgs, ... }:

let
  inherit (config.denbeigh.services.router) interfaces;
in
{
  config = {
    # NOTE: This is usually created implicitly by dhcpd's systemd job, but we
    # need it to exist by the time this is being run.
    # https://github.com/NixOS/nixpkgs/blob/25e3d4c0d3591c99929b1ec07883177f6ea70c9d/nixos/modules/services/networking/kea.nix#L255
    users = {
      users.kea = {
        isSystemUser = true;
        description = "kea service user";
        group = "${config.users.groups.kea.name}";
      };
      groups.kea = { };
    };

    age.secrets.dhcp-dns-update-key = {
      file = ../../../secrets/dhcpDnsAuthKeyKea.age;
      owner = config.users.users.kea.name;
    };

    networking = {
      useDHCP = false;
    };

    services = {
      kea = {
        dhcp4 = {
          enable = true;
          settings = {
            valid-lifetime = 4000;
            renew-timer = 1000;
            rebind-timer = 2000;

            interfaces-config = {
              interfaces = [ interfaces.lan ];
            };

            lease-database = {
              type = "memfile";
              persist = true;
              # TODO: do we need to assert this exists?
              name = "/var/lib/private/kea/dhcp4.leases";
            };

            option-data = [
              {
                name = "domain-name-servers";
                data = "10.69.1.1";
              }
              {
                name = "broadcast-address";
                data = "10.69.1.255";
              }
              {
                name = "routers";
                data = "10.69.1.1";
              }
              {
                name = "domain-name";
                data = "sfo.denbeigh.cloud";
              }
              {
                name = "domain-search";
                data = "sfo.denbeigh.cloud";
              }
            ];

            subnet4 = [
              {
                subnet = "10.69.1.0/24";
                pools = [
                  {
                    pool = "10.69.1.32 - 10.69.1.254";
                  }
                ];
              }
            ];
          };
        };

        dhcp-ddns = {
          enable = true;
          # NOTE: can't reference a secret from a file without doing this
          configFile =
            let
              configContent = ''
                {
                  "DhcpDdns": {
                    "forward-ddns": {
                      "ddns-domains": [
                        {
                          "dns-servers": [
                            {
                              "ip-address": "127.0.0.1"
                            }
                          ],
                          "key-name": "local",
                          "name": "sfo.denbeigh.cloud."
                        }
                      ]
                    },
                    "reverse-ddns": {
                      "ddns-domains": [
                        {
                          "dns-servers": [
                            {
                              "ip-address": "127.0.0.1"
                            }
                          ],
                          "key-name": "local",
                          "name": ".in-addr.arpa."
                        }
                      ]
                    },
                    "tsig-keys": [
                      <?include "${config.age.secrets.dhcp-dns-update-key.path}"?>
                    ]
                  }
                }
              '';
            in
            pkgs.writeText "ddns.conf" configContent;
        };
      };
    };
  };
}
