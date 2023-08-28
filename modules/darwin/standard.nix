{ self, config, pkgs, lib, ... }:

let
  cfg = config.denbeigh;

  inherit (lib) mkDefault;
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
    ../common/tailscale.nix
  ];

  config = {
    denbeigh.tailscale.enable = mkDefault true;

    services.nix-daemon.enable = true;

    users.users.${cfg.user.username} = {
      name = cfg.user.username;
      home = "/Users/${cfg.user.username}";
    };
  };
}
