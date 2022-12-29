{ config, lib, pkgs, cfdyndns-src, ... }:

let
  overlay = final: prev:
    {
      cfdyndns = prev.callPackage ../../../3rdparty/cfdyndns {
        inherit cfdyndns-src;
      };
    };

  inherit (lib) concatStringsSep escapeShellArg mkEnableOption mkIf mkOption types;
  cfg = config.denbeigh.services.cfdyndns;
in
{

  options.denbeigh.services.cfdyndns = {
    enable = mkEnableOption "Cloudflare DDNS Client";

    email = mkOption {
      type = types.str;
      default = "denbeigh+cloudflare@denbeighstevens.com";
      description = ''
        Email address used for Cloudflare authentication.
      '';
    };

    records = mkOption {
      type = types.listOf types.str;
      description = ''
        Records to update in Cloudflare.
      '';
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ overlay ];

    age.secrets.cloudflareAPIToken = {
      file = ../../../secrets/cloudflareAPIToken.age;
      owner = "cfdyndns";
      group = "cfdyndns";
      mode = "440";
    };

    users = {
      users.cfdyndns = {
        group = "cfdyndns";
        isSystemUser = true;
      };

      groups.cfdyndns = {};
    };

    # https://github.com/NixOS/nixpkgs/blob/b4d850f36fad7c3c20932be2c7e5b8cbc87211d5/nixos/modules/services/misc/cfdyndns.nix#L47
    # NOTE: We don't use the in-built cfdyndns because it's an old version that
    # doesn't support api tokens.
    systemd.services.cfdyndns = {
      description = "Cloudflare DDNS Client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      startAt = "*:0/5";
      serviceConfig = {
        Type = "simple";
        User = "cfdyndns";
        Group = "cfdyndns";
      };
      environment = {
        CLOUDFLARE_EMAIL="${cfg.email}";
        CLOUDFLARE_RECORDS="${concatStringsSep "," cfg.records}";
      };

      script = ''
        export CLOUDFLARE_APITOKEN="$(cat ${escapeShellArg config.age.secrets.cloudflareAPIToken.path})"
        ${pkgs.cfdyndns}/bin/cfdyndns
      '';
    };
  };
}
