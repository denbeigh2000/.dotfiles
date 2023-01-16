{ noisetorch-src, config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
  inherit (pkgs) callPackage;
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
  inherit (config.denbeigh) graphical;

  noisetorch = callPackage ../../3rdparty/noisetorch {
    inherit noisetorch-src;
  };

  cfg = config.services.noisetorch;
in
{
  options = {
    services.noisetorch = {
      enable = mkOption {
        type = types.bool;
        default = graphical && isLinux;
        example = true;
        description = ''
          Whether to install NoiseTorch and associated systemd definitions
        '';
      };

      package = mkOption {
        type = types.package;
        default = noisetorch;
        description = ''
          The NoiseTorch package to run
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.noisetorch = {
      Unit = {
        Description = "NoiseTorch noise suppression";
        After = [ "graphical-session.target" ];
        Requires = [ "pulseaudio.socket" ];
      };

      Service = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${noisetorch}/bin/noisetorch -i";
        ExecStop = "${noisetorch}/bin/noisetorch -u";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
