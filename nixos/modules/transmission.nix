{ pkgs, lib, config, ... }:

with builtins;
{
  imports = [ ./nginx/transmission.nix ];
  options =
    with lib.options;
    with lib.types;
    {
      denbeigh.transmission = {
        enable = mkEnableOption "Enable Transmission BitTorrent server";

        group = mkOption {
          type = str;
          default = "transmission";
          description = lib.mdDoc "Group account under which Transmission runs";
        };

        downloadDir = mkOption {
          type = str;
          default = "/data/downloads";
          description = lib.mdDoc "Directory to write downloads to.";
        };

        performanceNetParameters = mkOption {
          type = bool;
          default = true;
          description = lib.mdDoc "Enable kernel parameters to open more connections";
        };
      };
    };

  config =
    let
      cfg = config.denbeigh.transmission;
    in
    lib.mkIf cfg.enable {
      services.transmission = {
        inherit (cfg) enable group performanceNetParameters;

        downloadDirPermissions = "770";

        openRPCPort = false; # this is then default, but ensure this just in case that changes.

        settings = {
          blocklist-url = "https://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
          blocklist-enabled = true;

          download-dir = cfg.downloadDir;

          incomplete-dir-enabled = false;
          umask = 002;
          watch-dir-enabled = false;

          cache-size-mb = 8;
          encryption = 2; # require encryption from peers

          peer-limit-global = 50000;
          peer-limit-per-torrent = 1000;

          peer-port-random-on-start = true;

          download-queue-enabled = false; # disable downloads waiting in queue

          idle-seeding-limit = 60 * 24; # minutes
          idle-seeding-limit-enabled = true; # stop seeding after a period of inactivity
          ratio-limit = 1.5;
          ratio-limit-enabled = true;
        };
      };
    };
}
