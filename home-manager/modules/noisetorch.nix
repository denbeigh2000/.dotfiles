{ noisetorch-src, config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
  inherit (pkgs) callPackage libcap writeShellScriptBin;
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
  inherit (config.denbeigh) graphical;

  noisetorch = callPackage ../../3rdparty/noisetorch {
    inherit noisetorch-src;
  };

  # This cannot be run on a remote build machine, and setcap wrappers don't
  # really make sense with this as they'll just make our systemd service fail.
  add-noisetorch-setcap = writeShellScriptBin "add-nt-setcap" ''
    if [[ "$(id -u)" != 0 ]]
    then
      echo "This script must be run as root" >&2
      exit 1
    fi

    ${libcap}/bin/setcap 'CAP_SYS_RESOURCE=+ep' ${noisetorch}/bin/noisetorch
  '';

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
    home.packages = [ noisetorch add-noisetorch-setcap ];

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
