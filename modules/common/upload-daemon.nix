{ self, config, lib, ... }:

let
  inherit (config.denbeigh) machine;
  cfg = config.denbeigh.nix-upload-daemon;
in
{
  options = {
    denbeigh.nix-upload-daemon =
      let
        inherit (lib) mkOption types;
      in
      {
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

  config = {
    assertions = [
      {
        assertion = !(machine.work && cfg.enable);
        message = "Do **NOT** upload work packages to personal nix store";
      }
    ];
  } // mkIf cfg.enable ({
    nixpkgs.overlays = [ self.inputs.nix-upload-daemon.overlays.default ];

    age.secrets.remoteBuildSignKey = {
      file = ../../secrets/remoteBuildSignKey.age;
      owner = cfg.username;
      mode = "600";
    };

    age.secrets.remoteBuildUploadKey = {
      file = ../../secrets/remoteBuildUploadKey.age;
      owner = cfg.username;
      mode = "600";
    };

    services.nix-upload-daemon = {
      inherit (cfg) enable username workers target binding;

      post-build-hook = {
        enable = true;
        secretKey = config.age.secrets.remoteBuildSignKey.path;
      };
    };

    nix.settings.trusted-users = [ config.denbeigh.user.username ];
  });
}
