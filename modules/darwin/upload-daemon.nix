{ self, pkgs, lib, config, ... }:

let
  inherit (config.denbeigh) machine;
in
{
  imports = [
    self.inputs.agenix.darwinModules.default
    self.inputs.nix-upload-daemon.darwinModules.default
    ../common/upload-daemon.nix
  ];

  options = {
    denbeigh.nix-upload-daemon.enable = lib.mkOption {
      type = lib.types.bool;
      # NOTE: Disabled until a better solution for running ssh on a
      # non-standard port.
      default = false;
      # default = !machine.work;
    };
  };
  config =
    let
      inherit (lib) mkIf;
      cfg = config.denbeigh.nix-upload-daemon;
    in
    mkIf cfg.enable {
      age.identityPaths =
        let
          inherit (config.denbeigh.user) username keys;
        in
        builtins.map (key: "/Users/${username}/.ssh/${key}") keys;
    };
}
