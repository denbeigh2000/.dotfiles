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
      file = ../../../secrets/dhcpDnsAuthKeyKea.age;
      # https://github.com/NixOS/nixpkgs/blob/25e3d4c0d3591c99929b1ec07883177f6ea70c9d/nixos/modules/services/networking/kea.nix#L255
      owner = "kea";
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
          settings = {
            forward-ddns = {
              ddns-domains = [
                {
                  name = "sfo.denbeigh.cloud.";
                  key-name = "local";
                  dns-servers = [{ "ip-address" = "127.0.0.1"; }];
                }
              ];
            };
            reverse-ddns = {
              ddns-domains = [
                {
                  name = ".in-addr.arpa.";
                  key-name = "local";
                  dns-servers = [{ ip-address = "127.0.0.1"; }];
                }
              ];
            };
            tsig-keys = {
              name = "local";
              algorithm = "HMAC-SHA256";
              # TODO: test <?include > works from within a string
              secret = "<?include \"${config.age.secrets.dhcp-dns-update-key.path}\">";
            };
          };
        };
      };
    };
  };
}
