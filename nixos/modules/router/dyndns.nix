{ config, lib, pkgs, cfdyndns-src, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.denbeigh.services.router.ddns;
in
{
  imports = [ ../3rdparty/cfdyndns ];

  options.denbeigh.services.router.ddns = {
    enable = mkEnableOption "Enable DDNS setting for CF-managed domain/s";

    records = mkOption {
      type = types.listOf types.str;
      default = [ "ddns.denb.ee" ];
      description = ''
        Records to update in Cloudflare.
      '';
    };
  };

  config = {
    denbeigh.services.cfdyndns = {
      enable = true;
      inherit (cfg) records;
      secretKeyPath = config.age.secrets.cloudflareAPIToken.path;

      user = "cfdyndns";
      group = "cfdyndns";
    };

    age.secrets.cloudflareAPIToken = {
      file = ../../../secrets/cloudflareAPIToken.age;
      owner = "cfdyndns";
      group = "cfdyndns";
      mode = "440";
    };
  };
}
