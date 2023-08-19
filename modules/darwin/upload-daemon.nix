{ pkgs, lib, config, agenix, nix-upload-daemon, ... }:

let
  inherit (config.denbeigh) machine;
in
{
  imports = [
    agenix.darwinModules.default
    nix-upload-daemon.darwinModules.default
    ../common/upload-daemon.nix
  ];

  options = {
    denbeigh.nix-upload-daemon.enable = lib.mkOption {
      type = lib.types.bool;
      default = !machine.work;
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