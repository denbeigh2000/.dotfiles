{ config, lib, pkgs, ... }:

let

  cfg = config.denbeigh.services.uxplay;

  ports = {
    rtsp = 554;
    daap = 3689;
    mdns = 5353;

    uxplay = lib.lists.range cfg.ports (cfg.ports + 2);
  };
in

{
  options = {
    denbeigh.services.uxplay = {
      enable = lib.mkEnableOption "uxPlay AirPlay receiver";

      ports = lib.mkOption {
        type = lib.types.int;
        description = ''
          this and the next 2 greater ports will be used to
          coordinate and receive AirPlay data
        '';
        default = 6150;
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        description = ''
          If true, the necessary ports on the firewall will be opened to serve
          airplay traffic.

          This includes ${ports.rtsp}, ${ports.daap} and ${ports.mdns} (as well
          as the range specified in other config)
        '';
        default = true;
      };

      package = lib.mkPackageOption pkgs "uxplay" { };

      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          The identifier to advertise on AirPlay. If unset, will use uxPlay's
          default behaviour (system hostname).
        '';
        default = null;
      };

      appendHostname = lib.mkOption {
        type = lib.types.bool;
        description = ''
          If true, @<hostname> will be appended to advertised AirPlay name.
        '';
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.uxplay = {
      linger = true;
      group = "uxplay";
      isNormalUser = true;
      extraGroups = [ "audio" ];
    };

    users.groups.uxplay = { };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = with ports; ([ rtsp daap ] ++ uxplay);
      allowedUDPPorts = with ports; ([ rtsp mdns ] ++ uxplay);
    };

    systemd.user.services.uxplay = {
      enable = true;
      # just disabling these for now - network-online.target doesn't seem to
      # exist (anymore? in user-land? something else???) and unsure of
      # sound.target
      # after = [ "network-online.target" "sound.target" ]; # "user@uxplay" ];
      # requires = [ "network-online.target" "sound.target" ];
      # NOTE: wantedBy, not requiredBy to ensure a successful boot in case of
      # failure
      wantedBy = [ "default.target" ];

      serviceConfig = {
        ExecStart =
          let
            nameFlag = if cfg.name != null then "-n '${cfg.name}'" else "";
            appendHostnameFlag = if (!cfg.appendHostname) then "-nh" else "";
          in
          "${cfg.package}/bin/uxplay ${nameFlag} ${appendHostnameFlag} -p ${builtins.toString cfg.ports}";
        RuntimeDirectory = "uxplay";
      };

      unitConfig = {
        ConditionUser = "uxplay";
      };
    };
  };
}

