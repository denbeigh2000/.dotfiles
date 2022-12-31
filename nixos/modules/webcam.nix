{ config, pkgs, lib, ... }:

let
  # TODO: Can we get this from the running system instead?
  kernel = config.boot.kernelPackages;

  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (config.denbeigh.user) username;
  cfg = config.denbeigh.webcam;
in
{
  options.denbeigh.webcam = {
    enable = mkEnableOption "Manage v4l2-based webcam";

    videoDevice = mkOption {
      type = types.str;
      description = ''
        Video device to be used by webcam.
      '';
    };
  };

  config = mkIf cfg.enable {
    # TODO: Verify this is all the permissions we need to give our user
    users.users.${username}.extraGroups = [ "video" ];

    # NOTE: Confirm extra config options here are applied at boot time
    boot = {
      extraModulePackages = [ kernel.v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
      # TODO Fill in these options with ones appropriate to me
      extraModprobeConfig = ''
        options v4l2loopback ...
      '';

    environment.systemPackages = with pkgs; [
      gphoto2
      libv4l
      v4l-utils
    ];
  };
}
