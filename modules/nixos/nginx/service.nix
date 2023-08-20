{ name
, backend
, tailscale ? true
, ssl ? true
, extraConfig ? {}
}:

{ config, lib, ... }:
let
  cfg = config.denbeigh.services.www.${name};
  inherit (lib) mkEnableOption mkIf mkOption types;
in
{
  options.denbeigh.services.www.${name} = {
    enable = mkEnableOption "${name} web service";

    backend = mkOption {
      type = types.str;
      default = backend;
      description = ''
        Backend destination for ${name}.
      '';
    };

    extraConfig = mkOption {
      default = extraConfig;
      type = types.attrs;
      description = ''
        Additional config to pass to the nginx virtual host verbatim.
      '';
    };

    tailscale = mkOption {
      type = types.bool;
      default = tailscale;
      description = ''
        Expose ${name} only over Tailscale (enforces SSL).
      '';
    };

    ssl = mkOption {
      type = types.bool;
      default = ssl;
      description = ''
        Expose ${name} only over SSL.
      '';
    };
  };

  config = mkIf cfg.enable {
    denbeigh.services.www.services = [{
      inherit name;
      inherit (cfg) backend extraConfig ssl tailscale;
    }];
  };
}
