{ lib, config, ... }:

let
  ports = {
    spotifyd = 7111;
    rtsp = 554;
    daap = 3689;
    mdns = 5353;

    uxplay = [ 6150 6151 6152 ];
  };

  cfg = config.denbeigh.audio-streaming;
in

{
  options.denbeigh.audio-streaming = {
    enable = lib.options.mkEnableOption "audio streaming services";
    name = lib.options.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = with ports; ([ spotifyd rtsp daap ] ++ uxplay);
      allowedUDPPorts = with ports; ([ rtsp mdns ] ++ uxplay);
    };

    users = {
      users.audio-streamer = {
        linger = true;
        group = "audio-streamer";
        isSystemUser = true;
        extraGroups = [ "audio" ];
      };

      groups = {
        audio-streamer = { };
      };
    };

    services = {
      avahi = {
        enable = cfg.enable;
        openFirewall = true;
        nssmdns4 = true;
        # nssmdns6 = true;
        ipv4 = true;
        # ipv6 = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
          userServices = true;
        };
      };

      spotifyd = {
        enable = cfg.enable;

        settings.global = {
          device_name = cfg.name;
          zeroconf_port = ports.spotifyd;
        };
      };

      resolved = {
        extraConfig = ''
          MulticastDNS=no
        '';
      };

      # Adapted from: https://wiki.nixos.org/wiki/PipeWire#Headless_operation
      pipewire = lib.mkIf cfg.enable {
        enable = cfg.enable;
        # Socket activation too slow for headless; start at boot instead.
        socketActivation = false;
      };

    };

    # Adapted from: https://wiki.nixos.org/wiki/PipeWire#Headless_operation
    # Start WirePlumber (with PipeWire) at boot.
    systemd.user.services.wireplumber.wantedBy = [ "default.target" ];
  };
}
