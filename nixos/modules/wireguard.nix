{ pkgs, config, ... }:

let
  ips = [ "10.67.192.214/32" "fc00:bbbb:bbbb:bb01::4:c0d5/128" ];
  nameservers = [ "8.8.8.8" "8.8.4.4" ];
  servers = {
    us145-wireguard = {
      endpoint = "193.27.13.130:51820";
      publicKey = "MXSRliYAgPs3/BKO0pxLCDz4wTCQ4cafj02J1LriBj4=";
    };
    us150-wireguard = {
      endpoint = "193.27.13.226:51820";
      publicKey = "bigXstWXYiY7BznqpvHr40hyhcAXCyDsajLJ+HxRTk8=";
    };
    us38-wireguard = {
      endpoint = "174.127.113.16:51820";
      publicKey = "EWuW/w7GpnxKdl0sr+dfxJ3DTxjMN6JWs/GR6OIzgB4=";
    };
    us146-wireguard = {
      endpoint = "193.27.13.146:51820";
      publicKey = "1QfJqj4XweHehHtQyS3kPibLXVIB8gB72ECLdxrgfWM=";
    };
    us36-wireguard = {
      endpoint = "174.127.113.14:51820";
      publicKey = "fb9f0n73/qk9wvQQ9ufo7EZmeIH9bxmjETLdetuMyz8=";
    };
    us236-wireguard = {
      endpoint = "96.44.191.146:51820";
      publicKey = "H7CKyeh+CpwMJyeY5s203PUEYqqTiZyp7ukdfczWKj8=";
    };
    us154-wireguard = {
      endpoint = "194.110.112.34:51820";
      publicKey = "AFmZ9bQhiP4yCbAddJTpxbzF/IWlNgjrzN0OqqCE6A8=";
    };
    us34-wireguard = {
      endpoint = "174.127.113.12:51820";
      publicKey = "GCfWfE0241Hj8oSZIDQzk9VsLVC5VQ3MgFAEdhepNyA=";
    };
    us148-wireguard = {
      endpoint = "193.27.13.194:51820";
      publicKey = "yK1wfMTkMbksuR7+rlEbkq6mk5wsdyIJYSD9fB/htnA=";
    };
    us33-wireguard = {
      endpoint = "174.127.113.11:51820";
      publicKey = "d0QX/luq22c8W+SEeegfI02NL1gCg7F6HSZFiDZK4k8=";
    };
    us39-wireguard = {
      endpoint = "174.127.113.17:51820";
      publicKey = "fjO/un6d9DFtxjhwbe8cMohORIgbPFN0WgLw/LdHoRg=";
    };
    us149-wireguard = {
      endpoint = "193.27.13.210:51820";
      publicKey = "vh34NFVrwEKbmX+Rqy5xKyQ81unOWLb0DpYXSGHLxyk=";
    };
    us153-wireguard = {
      endpoint = "194.110.112.18:51820";
      publicKey = "GYU0qZ/in7Bw9mxgQw1z5hAuTbXF8Tt8rGyAD7rA0Ho=";
    };
    us147-wireguard = {
      endpoint = "193.27.13.162:51820";
      publicKey = "Q/slQ6Agjqp6iNvfbTGyz7CXv/LgsK4XnJil7UE60ng=";
    };
    us-dal-wg-401 = {
      endpoint = "37.19.200.156:51820";
      publicKey = "xZsnCxFN7pOvx6YlTbi92copdsY5xgekTCp//VUMyhE=";
    };
    us32-wireguard = {
      endpoint = "174.127.113.10:51820";
      publicKey = "jHxY2OKpxjqAwWH4r1Pb2K6xDUDt087ivxpM1KpE0Ec=";
    };
    us37-wireguard = {
      endpoint = "174.127.113.15:51820";
      publicKey = "smo7KmPLfKStrAlIwU5Vmr2aCD/UNUfR6LrUAraY3jY=";
    };
    us35-wireguard = {
      endpoint = "174.127.113.13:51820";
      publicKey = "sUve70TE2F3AaSGRPjN5aYr4um9OlKlIbnDw/2Ab8xg=";
    };
    us240-wireguard = {
      endpoint = "96.44.189.98:51820";
      publicKey = "Z3z461A/wSb1i41+Maz14YKfLezJA7BYk1kkUj6Gpno=";
    };
    us235-wireguard = {
      endpoint = "96.44.191.130:51820";
      publicKey = "/eAFrbWF72bLtQC0u0p8q/NXYq6dwrst4ZXuSx9HXHE=";
    };
    us30-wireguard = {
      endpoint = "174.127.113.8:51820";
      publicKey = "RW+wwTv4BqRNbHPZFcIwl74f9kuRQlFLxnaocpMyKgw=";
    };
    us143-wireguard = {
      endpoint = "193.27.13.98:51820";
      publicKey = "ys1/HwvP8ajGFVUooMA4CjE11QGqZUCdcO0uw7pxm3c=";
    };
    us270-wireguard = {
      endpoint = "37.19.200.130:51820";
      publicKey = "rzv9QSk5+vKHQ5zusPtxCS8wcrntkkQSml+7nJJJ1h8=";
    };
    us152-wireguard = {
      endpoint = "194.110.112.2:51820";
      publicKey = "fymKfaPctNpWCfC4xGl9UjZQ4bvEXT6GTK1+7DtVYBk=";
    };
    us144-wireguard = {
      endpoint = "193.27.13.114:51820";
      publicKey = "oLDrbdUAs51AAA9TjFnSvmmfV85dp2ZWFqr29P2HxzM=";
    };
    us31-wireguard = {
      endpoint = "174.127.113.9:51820";
      publicKey = "jByGGMuJ53aax6Kvo5CTL7Bz2e9ZglFgHbC6IOoux2o=";
    };
    us151-wireguard = {
      endpoint = "193.27.13.242:51820";
      publicKey = "RRQAnqeXwqxhltKBEFWdg9nwoPraRMvr7LIE91kg+zg=";
    };
  };

in
{
  config = {
    age.secrets.vpnPrivateKey.file = ../../secrets/vpnPrivateKey.age;

    networking =
      let
        inherit (builtins) concatStringsSep fromJSON readFile;
        inherit (pkgs.lib) mapAttrsToList;
        # NOTE: No actual secrets should be kept in this file, it's OK if its
        # contents end up in the nix store (private key is in a separate secret)
        # vpnConfig = fromJSON (readFile config.age.secrets.vpn.path);

        vpn = {
          interfaceName = "wg0";
          table = "61";
          mark = "61";

          # TODO: Expose as module options
          users = [ "transmission" "jackett" ];
        };

        # Creates a network table <num> that routes all traffic through our interface
        setupTable = num: ''
          TABLE_ROUTES="$(ip route list table ${num} || echo)"
          if [[ "$TABLE_ROUTES" != "" ]]
          then
            ${flushTable num}
          fi

          ip route add default dev ${vpn.interfaceName} table ${num}
          unset TABLE_ROUTES
        '';

        # Clears all rules from our table <num>
        flushTable = num: ''
          ip route flush table ${num}
        '';

        # Adds a rule to all traffic from user <uid> to consult our table <num>
        routeUser = uid: num: ''
          USER_RULE="$(ip rule show uidrange ${uid}-${uid} lookup ${num})"
          if [[ "$USER_RULE" != "" ]]
          then
            ${unRouteUser uid num}
          fi

          ip rule add uidrange ${uid}-${uid} lookup ${num} prio 6120
          unset USER_RULE
        '';

        # Deletes all rules telling <user> to consume our table <num>
        unRouteUser = uid: num: ''
          ip rule del uidrange ${uid}-${uid} lookup ${num}
        '';

      in
      {
        inherit nameservers;

        wireguard = {
          enable = true;
          interfaces."${vpn.interfaceName}" = {
            inherit ips;
            # inherit (vpn) table;

            privateKeyFile = config.age.secrets.vpnPrivateKey.path;

            # Set up a different routing table, and don't set up default
            # routing rules, so that we can route traffic from only certain
            # applications through the VPN
            allowedIPsAsRoutes = false;

            peers = mapAttrsToList
              (hostname: config: {
                inherit (config) publicKey endpoint;
                allowedIPs = [ "0.0.0.0/0" "::0/0" ];
              })
              servers;

            # https://unix.stackexchange.com/a/589605
            # https://github.com/davidtwco/veritas/blob/567e002fbc0ca5f5576ed37f5c22cae82fc31d1a/nixos/modules/per-user-vpn.nix#L158-L175
            # https://www.wireguard.com/netns

            # TODO: Expose configuration as variables
            postSetup = ''
              ${setupTable vpn.table}
              ${routeUser (toString config.users.users.transmission.uid) vpn.table}
              ${routeUser (toString config.users.users.jackett.uid) vpn.table}
            '';

            postShutdown = ''
              ${unRouteUser (toString config.users.users.transmission.uid) vpn.table}
              ${unRouteUser (toString config.users.users.jackett.uid) vpn.table}
              ${flushTable vpn.table}
            '';
          };
        };
      };
  };
}
