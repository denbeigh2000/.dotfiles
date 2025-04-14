{ pkgs, config, lib, ... }:

let
  cfg = config.denbeigh.services.spotifyd;
in

{
  options = {
    denbeigh.services.spotifyd = {
      enable = lib.mkEnableOption "uxPlay AirPlay receiver";

      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          The identifier to advertise on Spotify Connect. If unset, will use
          spotifyd's default behaviour (system hostname).
        '';
        default = null;
      };

      port = lib.mkOption {
        type = lib.types.int;
        description = ''
          Port to use for Spotifyd
        '';

        default = 7111;
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        description = ''
          If true (the default), the configured port to use will be exposed over TCP.
        '';
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.spotifyd = {
      linger = true;
      group = "spotifyd";
      isSystemUser = true;
      extraGroups = [ "audio" ];
    };
    users.groups.spotifyd = { };

    # services.spotifyd = {
    #   enable = cfg.enable;

    #   settings.global =
    #     let
    #       name =
    #         if cfg.name != null
    #         then { device_name = cfg.name; }
    #         else { };
    #     in
    #     (name // { zeroconf_port = cfg.port; });
    # };

    # TODO: we run this as a user service instead?
    # systemd.services.spotifyd.serviceConfig = {
    #   # ensure we override this and use our explicit user with linger enabled
    #   DynamicUser = lib.mkForce false;
    #   User = "spotifyd";
    # };

    systemd.user.services.spotifyd =
      let
        toml = pkgs.formats.toml { };
        settings =
          let
            name =
              if cfg.name != null
              then { device_name = cfg.name; }
              else { };
          in
          (name // { zeroconf_port = cfg.port; });
        settingsToml = toml.generate "spotifyd.conf" settings;
      in
      {
        wantedBy = [ "default.target" ];
        description = "spotifyd, a Spotify playing daemon";
        environment.SHELL = "/bin/sh";
        serviceConfig = {
          # TODO: better cache path? need to confirm correct user-specific
          # behaviour after removing dynamic user
          ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --cache-path /tmp/spotifyd --config-path ${settingsToml}";
          Restart = "always";
          RestartSec = 12;
          # CacheDirectory = "spotifyd";
        };
        unitConfig = {
          ConditionUser = "spotifyd";
        };
      };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
