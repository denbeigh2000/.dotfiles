{ lib, config, ... }:

let
  cfg = config.denbeigh.audio-streaming;
in

{
  imports = [ ./uxplay.nix ./spotifyd.nix ];

  options.denbeigh.audio-streaming = {
    enable = lib.options.mkEnableOption "audio streaming services";
    name = lib.options.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
    };
  };

  config = lib.mkIf cfg.enable {
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

      resolved = {
        extraConfig = ''
          MulticastDNS=no
        '';
      };
    };

    denbeigh.services = {
      uxplay = { inherit (cfg) enable name; };
      spotifyd = { inherit (cfg) enable name; };
    };

    services.xserver.windowManager.tinywm.enable = true;
    # Headless audio Sucks(tm). Just run a teeny tiny display manager. You
    # won't notice the resource usage, and you can spend your life doing all
    # those other things you always dreamed of that weren't fucking around with
    # esoteric audio configurations on Linux.
    services.displayManager = lib.mkIf cfg.enable {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = "spotifyd";
      };
      defaultSession = "none+tinywm";
    };
  };
}
