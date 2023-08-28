{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.denbeigh.tailscale;
in
{
  options.denbeigh.tailscale = {
    enable = mkEnableOption "tailscale daemon";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    environment.systemPackages = [ pkgs.tailscale ];
  };
}
