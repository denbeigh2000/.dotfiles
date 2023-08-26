{ self, config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;

  cfg = config.denbeigh.htop;
in

{
  options = {
    denbeigh.htop.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install and manage htop.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      settings =
        let
          inherit (config.lib.htop) leftMeters rightMeters bar text;
        in
        {
          # fields = htopFields;
        } // (leftMeters [
          (bar "AllCPUs2")
          (bar "Memory")
          (bar "Swap")
          (text "Zram")
        ]) // (rightMeters ([
          (text "Tasks")
          (text "LoadAverage")
          (text "Uptime")
        ] ++ (if !isDarwin then [ (text "Systemd") ] else [ ])));
    };
  };
}
