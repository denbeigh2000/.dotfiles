{ nixpkgs
, home-manager
, denbeigh-devtools
, ...
}@inputs:

let
  system = "aarch64-linux";
  host = {
    inherit system;
    work = false;
    hostname = "dev";
    username = "denbeigh";
    graphical = false;
  };

  specialArgs = inputs // { inherit host; };
in
{
  inherit system specialArgs;
  modules = [
    home-manager.nixosModules.home-manager

    ../modules/denbeigh.nix
    ../modules/flakes.nix
    ../modules/utils.nix
    ../modules/cloud
    ../modules/cloud/aws/aarch64.nix

    {
      networking = {
        hostName = "dev";
        domain = "denbeigh.cloud";
      };

      system.stateVersion = "22.05";
    }
  ];
}
