{ config, pkgs, lib, agenix, ... }:

let
  cfg = config.denbeigh;
in
{
  imports = [
    ../common/standard.nix
    ../common/variables.nix

    ./graphical.nix
    ./use-nix-cache.nix
    ./home.nix
    ./system-options.nix
    ./upload-daemon.nix
  ];

  config = {
    services.nix-daemon.enable = true;

    users.users.${cfg.user.username} = {
      name = cfg.user.username;
      home = "/Users/${cfg.user.username}";
    };
  };
}
