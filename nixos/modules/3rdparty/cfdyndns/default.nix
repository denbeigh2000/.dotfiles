{ config, lib, pkgs, cfdyndns-src, ... }:

let
  overlay = final: prev: {
    cfdyndns = prev.callPackage ../../../../3rdparty/cfdyndns {
      inherit cfdyndns-src;
    };
  };

  inherit (lib) concatStringsSep escapeShellArg mkEnableOption mkIf mkOption types;
  cfg = config.denbeigh.services.cfdyndns;
in
{

  options.denbeigh.services.cfdyndns = {
    enable = mkEnableOption "Cloudflare DDNS Client";

    records = mkOption {
      type = types.listOf types.str;
      description = ''
        Records to update in Cloudflare.
      '';
    };

    calendar = mkOption {
      type = types.str;
      default = "*:0/5";
      description = ''
        Schedule to execute check on
      '';
    };

    secretKeyPath = mkOption {
      type = types.path;
      description = ''
        Path to secret key to use when signing responses.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "cfdyndns";
      description = ''
        User to run service as.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "cfdyndns";
      description = ''
        Group to create for management user.
      '';
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ overlay ];

    users = {
      users.${cfg.user} = {
        group = cfg.group;
        isSystemUser = true;
      };

      groups.${cfg.group} = { };
    };

    # https://github.com/NixOS/nixpkgs/blob/b4d850f36fad7c3c20932be2c7e5b8cbc87211d5/nixos/modules/services/misc/cfdyndns.nix#L47
    # NOTE: We don't use the in-built cfdyndns because it's an old version that
    # doesn't support api tokens.
    systemd.services.cfdyndns = {
      description = "Cloudflare DDNS Client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      startAt = cfg.calendar;
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
      };
      environment = {
        CLOUDFLARE_RECORDS = "${concatStringsSep "," cfg.records}";
      };

      script = ''
        export CLOUDFLARE_APITOKEN="$(cat ${escapeShellArg cfg.secretKeyPath})"
        ${pkgs.cfdyndns}/bin/cfdyndns
      '';
    };
  };
}

