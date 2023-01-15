{ harmonia-src, config, pkgs, lib, ... }:

let
  inherit (builtins) toString;
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (pkgs) writeText;

  cfg = config.denbeigh.services.harmonia;
  configFileText = with cfg; ''
    bind = "${bindAddress}"
    workers = ${toString workers}
    max_connection_rate = ${toString maxConnectionRate}
    priority = ${toString priority}
    sign_key_path = "${secretKeyPath}"
  '';
  configFile = writeText "harmonia.toml" configFileText;

  overlay = final: prev: {
    harmonia = import ../../../../3rdparty/harmonia {
      inherit harmonia-src pkgs;
    };
  };
in
{
  options.denbeigh.services.harmonia = {
    enable = mkEnableOption "Harmonia nix-cache service";

    bindAddress = mkOption {
      type = types.str;
      default = "127.0.0.1:5000";
      description = ''
        TCP address for server to bind to.
      '';
    };

    workers = mkOption {
      type = types.ints.unsigned;
      default = 4;
      description = ''
        Number of thread workers to run.
      '';
    };

    maxConnectionRate = mkOption {
      type = types.ints.unsigned;
      default = 256;
      description = ''
        Maximum permitted open connections.
      '';
    };

    priority = mkOption {
      type = types.int;
      default = 30;
      description = ''
        Priority to report in info requests.
      '';
    };

    secretKeyPath = mkOption {
      type = types.path;
      description = ''
        Path to secret key for signing responses.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "harmonia";
      description = ''
        User to run the service as.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "harmonia";
      description = ''
        Group to create for the service user.
      '';
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ overlay ];

    systemd.services.harmonia = {
      description = "Harmonia nix cache";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      script = ''
        CONFIG_FILE="${configFile}" ${pkgs.harmonia}/bin/harmonia
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
