{ self, config, pkgs, lib, ... }:

let
  cfg = config.denbeigh;
in
{
  imports = (with self.darwinModules; [
    graphical
    use-nix-cache
    home
    system-options
    upload-daemon
  ]) ++ [
    ../common/standard.nix
    ../common/variables.nix
  ];

  config = {
    services.nix-daemon.enable = true;

    users.users.${cfg.user.username} = {
      name = cfg.user.username;
      home = "/Users/${cfg.user.username}";
    };
  };
}
