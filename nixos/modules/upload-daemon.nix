{ pkgs, lib, config, upload-daemon, ... }:

let
  inherit (config.denbeigh) machine nix-cache;
in
{
  imports = [ upload-daemon.nixosModules.default ];

  options = {
    destination =
      let
        inherit (lib) mkOption types;

      in
      {
        enable = mkOption {
          type = types.bool;
          default = !(machine.work || nix-cache.enable);
        };

        targets = mkOption {
          type = types.listOf types.str;
          default = [ "ssh-ng://bruce" ];
          description = "Stores to upload to";
        };

        workers = mkOption {
          type = types.int;
          default = 2;
          description = "Number of workers to run";
        };

        user = mkOption {
          type = types.str;
          default = "upload-daemon";
          description = "User to run uploader daemon as";
        };
      };
  };

  config =
    let
      inherit (lib) mkIf;
      cfg = config.denbeigh.upload-daemon;
    in
    {
      assertions = [
        {
          assertion = !(machine.work && cfg.enable);
          message = "Do **NOT** upload work packages to personal nix store";
        }

        {
          assertion = !(nix-cache.enable && cfg.enable);
          message = "The nix-cache shouldn't upload, because it serves from its' local store anyway.";
        }
      ];
    } // (mkIf cfg.enable {
      age.secrets.remoteBuildSignKey = {
        file = ../../secrets/remoteBuildSignKey.age;
        owner = cfg.user;
        group = cfg.group;
        mode = "600";
      };

      age.secrets.remoteBuildUploadKey = {
        file = ../../secrets/remoteBuildUploadKey.age;
        owner = cfg.user;
        group = cfg.group;
        mode = "600";
      };

      services.upload-daemon = {
        inherit (cfg) enable user workers targets;

        post-build-hook = {
          enable = true;
          secretKey = config.age.secrets.remoteBuildSignKey.path;
        };
      };

      # Doing this ensures the expected key is always created in a format that
      # ssh is happy with.
      system.activationScripts.set-user-pubkey.text =
        let
          inherit (cfg) user group;
          inherit (config.users.users.${user}) group home uid;
          inherit (config.users.groups.${group}) gid;

          sshDir = "${home}/.ssh";
          sshKeyFile = "${sshDir}/id_ed25519";
        in
        ''
          mkdir -p ${sshDir}
          chmod -R go-rwx ${sshDir}
          chown -R ${uid}:${gid} ${sshDir}
          cp ${config.age.secrets.remoteBuildUploadKey.path} ${sshKeyFile}
          chmod go-rwx ${sshKeyFile}
          chown ${uid}:${gid} ${sshKeyFile}
        '';
    });
}
