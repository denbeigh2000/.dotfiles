{ lib, config, ... }:

let
  cfg = config.denbeigh;
in
{
  imports = [
    ./base.nix
    ./use-nix-cache.nix
    ./home.nix
  ];

  config = {
    users.users.${cfg.user.username} = {
      name = cfg.user.username;
      home = "/Users/${cfg.user.username}";
    };
  };
}
