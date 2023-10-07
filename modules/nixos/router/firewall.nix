{ config, pkgs, lib, ... }:


let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.denbeigh.services.router;
in
{

  imports = [
    # Desired to route traffic from the home network over Tailscale
    ../tailscale.nix
  ];

  config = mkIf cfg.enable {
    # Enable IP forwarding
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;

      # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
      # By default, not automatically configure any IPv6 addresses.
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.all.autoconf" = 0;
      "net.ipv6.conf.all.use_tempaddr" = 0;

      # On WAN, allow IPv6 autoconfiguration and tempory address use.
      "net.ipv6.conf.${cfg.interfaces.wan}.accept_ra" = 2;
      "net.ipv6.conf.${cfg.interfaces.wan}.autoconf" = 1;
    };

    networking = {

      firewall.enable = false;
      nat.enable = false;
      # https://oxcrag.net/2021/12/25/build-your-own-router-with-nftables-part-1/
      # https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_home_router
      # https://francis.begyn.be/blog/nixos-home-router
      # https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes
      # NOTE: We're using NFTables here primarily so we can add a second NAT for Tailscale.
      nftables = {
        enable = true;
        # There appears to be resolution-ordering issues related to this which
        # lead to (either of) the networking device or the nf_flow_table kernel
        # module not being loaded. Skip validating ruleset to overcome this.
        # https://discourse.nixos.org/t/nftables-could-not-process-rule-no-such-file-or-directory/33031
        checkRuleset = false;
        ruleset = ''
          table inet filter {
            # enable flow offloading for better throughput
            flowtable f {
              hook ingress priority 0;
              devices = { ${cfg.interfaces.wan}, ${cfg.interfaces.lan } };
            }

            chain output {
              type filter hook output priority 100; policy accept;
            }

            chain input_lan {
              # SSH, DNS, DHCP
              ip protocol . th dport vmap {
                tcp . 22 : accept,
                udp . 53 : accept,
                tcp . 53 : accept,
                udp . 67 : accept,
              }
            }

            chain input_wan {
              # Certain forwarding rules etc can be added here in future
            }

            chain input {
              # Deny all by default
              type filter hook input priority filter; policy drop;

              # Permit all established/related connections
              ct state vmap {
                established : accept,
                related : accept,
                invalid : drop,
              } counter

              # ICMP is - mostly - our friend. Limit incoming pings somewhat but allow necessary information.
              ip protocol icmp icmp type { destination-unreachable, echo-reply, echo-request, source-quench, time-exceeded } limit rate 5/second accept
              # Drop obviously spoofed loopback traffic
              iifname "lo" ip daddr != 127.0.0.0/8 drop

              iifname vmap {
                lo: accept,
                ${cfg.interfaces.lan}: jump input_lan,
                ${cfg.interfaces.wan}: jump input_wan,
                ${config.services.tailscale.interfaceName}: jump input_lan,
              }
            }

            chain forward {
              type filter hook input priority filter; policy drop;

              # enable flow offloading for better throughput
              # TODO: this seems supported on this processor?
              # ip protocol {tcp, udp} flow offload @f

              ct state vmap {
                established : accept,
                related : accept,
                invalid : drop,
              }

              iifname { lo, ${cfg.interfaces.lan} } accept
            }
          }

          table ip nat {
            chain prerouting {
              type nat hook output priority -100; policy accept;
            }

            # Setup NAT masquerading on the WAN interface
            chain postrouting {
              type nat hook postrouting priority 800; policy accept;
              # TODO: add tailscale here
              iifname "${cfg.interfaces.lan}" oifname "${cfg.interfaces.wan}" masquerade
              iifname "${cfg.interfaces.lan}" oifname "${config.services.tailscale.interfaceName}" masquerade
            }
          }
        '';
      };
    };

    # TODO: https://francis.begyn.be/blog/nixos-home-router "Performance tuning"
  };
}
