{ pkgs, lib, config, agenix, nix-upload-daemon, ... }:

let
  inherit (config.denbeigh) machine;
in
{
  imports = [
    agenix.darwinModules.default
    nix-upload-daemon.darwinModules.default
  ];

  options = {
    denbeigh.nix-upload-daemon =
      let
        inherit (lib) mkOption types;
      in
      {
        enable = mkOption {
          type = types.bool;
          default = !machine.work;
        };

        binding = mkOption {
          type = types.str;
          default = "sock:///tmp/nix-upload-daemon.sock";
        };

        target = mkOption {
          type = types.str;
          default = "ssh-ng://nix-copy-receiver@bruce.denbeigh.cloud?ssh-key=${config.age.secrets.remoteBuildUploadKey.path}";
          description = "Store to upload to";
        };

        workers = mkOption {
          type = types.int;
          default = 2;
          description = "Number of workers to run";
        };

        username = mkOption {
          type = types.str;
          default = "nix-upload-daemon";
          description = "User to run uploader daemon as";
        };
      };
  };
  config =
    let
      inherit (lib) mkIf;
      cfg = config.denbeigh.nix-upload-daemon;
    in
    {
      assertions = [
        {
          assertion = !(machine.work && cfg.enable);
          message = "Do **NOT** upload work packages to personal nix store";
        }
      ];
    } // (mkIf cfg.enable {
      nixpkgs.overlays = [ nix-upload-daemon.overlays.default ];

      age.identityPaths =
        let
          inherit (config.denbeigh.user) username keys;
        in
        builtins.map (key: "/Users/${username}/.ssh/${key}") keys;
      age.secrets.remoteBuildSignKey = {
        file = ../../secrets/remoteBuildSignKey.age;
        owner = config.denbeigh.user.username;
        mode = "600";
      };

      age.secrets.remoteBuildUploadKey = {
        file = ../../secrets/remoteBuildUploadKey.age;
        owner = cfg.username;
        mode = "600";
      };

      nix.settings.trusted-users = [ config.denbeigh.user.username ];

      services.nix-upload-daemon = {
        inherit (cfg) enable username workers target binding;

        post-build-hook = {
          enable = true;
          secretKey = config.age.secrets.remoteBuildSignKey.path;
        };
      };
    });
}
