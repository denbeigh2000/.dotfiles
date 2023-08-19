{ config, lib }:

let
  inherit (lib) mkEnableOption mkOption;

  cfg = config.denbeigh.tailscale;
in
{
  options.denbeigh.tailscale = {
    enable = mkEnableOption "tailscale daemon";
  };

  config = {
    services.tailscale.enable = cfg.enable;
  };
}
