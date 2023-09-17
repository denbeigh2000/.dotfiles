{ self, config, pkgs, lib, ... }:

let
  inherit (pkgs) nix;
  inherit (lib) mkOption types;
  cfg = config.denbeigh;
in

{
  imports = [
    self.inputs.agenix.nixosModules.default

    ../common/standard.nix
    ../common/variables.nix
    ./denbeigh.nix
    ./utils.nix
    ./graphical.nix
    ./use-nix-cache.nix

    # Disabled by default
    ./ssh.nix
    ./webcam.nix
  ];

  options.denbeigh.machine = {
    domain = mkOption {
      type = types.str;
      default = "sfo.denbeigh.cloud";
      description = ''
        Networking domain of the machine.
      '';
    };
  };

  config = {
    networking = {
      hostName = cfg.machine.hostname;
      inherit (cfg.machine) domain;
    };

    services.chrony.enable = true;
  };
}
