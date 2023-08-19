{ config
, lib
, pkgs
, home-manager
, host
, denbeigh-devtools
, ...
}@inputs:

# TODO: May be missing some imports form lib
let
  inherit (lib) mkOption types;

  cfg = config.denbeigh;

in
{
  imports = [ home-manager.nixosModules.home-manager ];

  options.denbeigh.user = {
    username = mkOption {
      type = types.str;
      default = "denbeigh";
      description = ''
        Username of the user to provision on the system.
      '';
    };

    shell = mkOption {
      type = types.package;
      default = pkgs.zsh;
      description = ''
        Shell to use for the environment.
      '';
    };

    # TODO: Rename this?
    keys = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        The SSH key paths to expect to use.
      '';
    };
  };

  config = {
    nixpkgs.overlays = [ denbeigh-devtools.overlays.default ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit (inputs) agenix denbeigh-devtools fonts nixgl noisetorch-src;
      };
      # TODO: Need to be able to pass user-level config in here
      # Create an option in this module and combine?
      users.${cfg.user.username} = {
        denbeigh = {
          isNixOS = true;
          inherit (cfg) webcam;
          inherit (cfg.machine) graphical hostname;
          inherit (cfg.user) username keys;
          location = cfg.machine.location.coordinates;
        };

        imports = [
          ../home-manager/default.nix
        ];
      };
    };

    users.users.${cfg.user.username} = {
      isNormalUser = true;
      extraGroups = [ "docker" "wheel" ];
      shell = cfg.user.shell;

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGL5WQPkkTBBKKtJ0cYIdAvjz8mm7DtweeTvUKygP3jBPHQMJ63aRYHcOPq8UFo3ZpeFzbZG0M5rYgpgqk6ouo6csBvR81OYcVUjMGJ+ymnVNtmCh5rQLBcJ4U8h8oITxZuglkTcYpB11m1Ulgh7ewoIBgHFmd3cWs76b05jF8Eofxcnnbjsa/f+ui+nVWy6kuSw7El+FZEMjspVzp1HrL+lZA2ScNqrHlm4zPjQGSraWclEEKPtogWEuGWY/kgmx9qXoDhqH/a43slWbMW+x+BpDCGg4dNj4DxLqvpCDM2jPMy0a92GS1KqQUrKt2uurn4YlpLFgKD7RToRPwNd4b"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEhLcnb7GSelOV/3x0DYwzfIZgQ0QGaK3ma4NzXND79k"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnB5kKoXQDMIUwELNSFZO8pHZQeIqn7fxrt/pEBiIfy"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlSD0R2XzARKuBVfcw1EZ0MWhJky7q4STy4XYy2YIQO"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1kbs7aoRMqvQrgdoXTYUA/E/LDDTBdEXsRP2xJos1q"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqXRBsU3gLjNIGBxjkkt6z/jQL/oaC4TsLssdSl+DDzjhPgdpnOT5JN9R3d2SurZZOvZIZzSD2WjX05H9vPICOcX5jX5JDhXUUbsclaNekUSRRGf4BjusrBStWWdi8LgzNoZdWNrGM0eoRuigCGTovixjmsjVRehTEqI9aRgLxtVS4mvi1HgcDeER55ZOKROQlWtLuGlhzmD7PVSjcumx2dQrVKS2vcvEsrfSYkkX56U/W075JGduY/8FA49f167lKDomvn0F2Oo1RWotoTMtmjDakZqfDwZbura0b7qo0ORH4kl3G2RB0omI70T3usUXG8dl0wuVKpOj+ch9xJp+R"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrWuq0cLFKo4KKLYKF/SG3U/6/7U0o7JDHDeJOwadAf"
      ];
    };
  };
}
