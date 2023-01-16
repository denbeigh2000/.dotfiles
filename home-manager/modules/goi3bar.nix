{ goi3bar-src, config, pkgs, lib, ... }:

let
  # inherit (pkgs) 
  overlay = final: prev: {
    goi3bar = final.callPackage ../../3rdparty/goi3bar {
      inherit goi3bar-src;
    };
  };

  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.goi3bar;
in
{
  options = {
    goi3bar = {
      enable = mkEnableOption "goi3bar config";
      configPath = mkOption {
        type = types.path;
        default = "${config.home.homeDirectory}/.config/i3/config.json";
      };

      config = mkOption {
        type = types.attrs;
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    home.file."goi3bar-conf" = {
      target = cfg.configPath;
      content = (builtins.toJSON cfg.config);
    };
  };
}
