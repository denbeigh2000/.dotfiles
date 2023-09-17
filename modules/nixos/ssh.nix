{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkDefault mkIf mkOption types;

  cfg = config.denbeigh.ssh;
in
{
  options = {
    denbeigh.ssh = {
      enable = mkEnableOption "ssh to the machine";

      sshPort = mkOption {
        type = types.number;
        default = 22;
        description = ''
          Port to serve SSH on (if enabled).
        '';
      };
    };
  };

  config = {
    services.openssh = {
      # Set if enabled
      enable = mkIf cfg.enable true;
      ports = mkIf cfg.enable [ cfg.sshPort ];
      openFirewall = mkIf cfg.enable true;

      # Preferred security defaults, should be set regardless
      settings = {
        PermitRootLogin = mkDefault "no";
        PasswordAuthentication = mkDefault false;
        KbdInteractiveAuthentication = mkDefault false;
      };
    };
  };
}
