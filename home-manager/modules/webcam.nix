{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.options.denbeigh.webcam;
in
{
  options.denbeigh.webcam = {
    enable = mkEnableOption "Add webcam service";

    videoDevice = mkOption {
      type = types.str;
      description = ''
        Video device to be used by webcam.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.webcam = {
      Unit.Description = "Run v4l2-based webcam";

      script = ''
        "${pkgs.gphoto2}/bin/gphoto2 \
            --stdout \
            --capture-movie \
          | ${pkgs.ffmpeg}/bin/ffmpeg \
            -i - \
            -vcodec rawvideo \
            -pix_fmt yuv420p \
            -threads 0 \
            -f v4l2 \
            ${cfg.videoDevice}
      '';
    };
  };
}
