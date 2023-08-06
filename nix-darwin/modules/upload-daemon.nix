{ pkgs, lib, config, agenix, upload-daemon, ... }:

let
  inherit (config.denbeigh) machine;
in
{
  imports = [
    agenix.darwinModules.default
    upload-daemon.darwinModules.default
  ];

  options = {
    denbeigh.upload-daemon =
      let
        inherit (lib) mkOption types;
      in
      {
        enable = mkOption {
          type = types.bool;
          default = !machine.work;
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
      ];
    } // (mkIf cfg.enable {
      age.identityPaths =
        let
          inherit (config.denbeigh.user) username keys;
        in
        builtins.map (key: "/Users/${username}/.ssh/${key}") keys;
      age.secrets.remoteBuildSignKey = {
        file = ../../secrets/remoteBuildSignKey.age;
        owner = cfg.user;
        mode = "600";
      };

      age.secrets.remoteBuildUploadKey = {
        file = ../../secrets/remoteBuildUploadKey.age;
        owner = cfg.user;
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
      launchd.daemons.setup-ssh-key = {
        script = let
          inherit (builtins) toString;
          inherit (cfg) user;
          inherit (config.users.users.${user}) home uid;

          sshDir = "${home}/.ssh";
          sshKeyFile = "${sshDir}/id_ed25519";
        in
        ''
          mkdir -p ${sshDir}
          chmod -R go-rwx ${sshDir}
          chown -R ${toString uid}:daemon ${sshDir}
          cp ${config.age.secrets.remoteBuildUploadKey.path} ${sshKeyFile}
          chmod go-rwx ${sshKeyFile}
          chown ${toString uid}:daemon ${sshKeyFile}
        '';
        serviceConfig = {
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = false;
        };
      };

    });
}
