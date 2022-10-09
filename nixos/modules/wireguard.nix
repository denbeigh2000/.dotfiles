{ pkgs, config, ... }:

{
  config = {
    # VPN config, OK for contents to be stored in nix store
    age.secrets.vpn.file = ../../secrets/vpn.age;
    # Not OK to be stored in nix store
    age.secrets.vpnPrivateKey.file = ../../secrets/vpnPrivateKey.age;

    networking =
      let
        inherit (builtins) concatStringsSep fromJSON readFile;
        vpnConfig = fromJSON (readFile age.secrets.vpn.path);

        vpn = {
          interfaceName = "wg0";
          table = "vpn";
          mark = "61";

          # TODO: Expose as module options
          users = [ "transmission" ];
        };

      in
      {
        nameservers = vpnConfig.interface.dns;
        wireguard = {
          enable = true;
          interfaces."${vpn.interfaceName}" = {
            inherit (vpnconfig.interface) ips;
            inherit (vpn) table;

            privateKeyFile = age.secrets.vpn.path;

            # Set up a different routing table, and don't set up default
            # routing rules, so that we can route traffic from only certain
            # applications through the VPN
            allowedIPsAsRoutes = false;

            peers = map
              (peer: {
                inherit (peer) endpoint publicKey allowedIPs;
              })
              vpnConfig.peers;

              # https://unix.stackexchange.com/a/589605
              # https://github.com/davidtwco/veritas/blob/567e002fbc0ca5f5576ed37f5c22cae82fc31d1a/nixos/modules/per-user-vpn.nix#L158-L175
              postSetup = 
              let
                markForUser = user: ''
                  iptables -t vpn -A OUTPUT -m owner --uid-owner ${user} -j MARK --set-mark ${vpn.mark}
                '';

                markPackets = concatStringsSep "\n" (map markForUser vpn.users);
              in ''
                # Mark packets for all applicable users with mark ${vpn.mark}
                ${markPackets}

                # This should hopefully be added for me by NixOS.
                # ip route add default via ${vpnConfig.interface.ips[0]} dev ${vpn.interfaceName}

                if ! ip rule | egrep -q '^${vpn.mark}:'
                then
                  ip rule add fwmark ${vpn.mark} lookup ${vpn.table} prio ${vpn.mark}
                fi
              '';

              postShutdown = ''
                # Should also hopefully be done by NixOS.
                # ip route flush table ${vpn.table}
              '';
          };
        };
      };
  };
}
