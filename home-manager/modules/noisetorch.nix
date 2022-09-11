{ pkgs, lib, ... }:

with pkgs.lib;

let
  name = "noisetorch";
  cfg = config.services.noisetorch;

in
{
  options = {
    services.noisetorch = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to install NoiseTorch and associated systemd definitions
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.noisetorch;
        defaultText = "pkgs.noisetorch";
        description = ''
          The NoiseTorch package to run
        '';
      };
    };
  };

  config = lib.mkIf true {
    systemd.user.services.noisetorch = {
      Unit = {
        description = "NoiseTorch noise suppression";
        After = [ "graphical-session.target" ];
        Requires = [ "pulseaudio.socket" ];
      };

      Service = {
        type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i";
        ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
