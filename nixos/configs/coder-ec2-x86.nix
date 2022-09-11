{ nixpkgs
, home-manager
, denbeigh-devtools
, ...
}@inputs:

let
  system =  "x86_64-linux";
  overlays = [
    denbeigh-devtools.overlay
  ];
  hostArgs = {
    inherit system;
    host = {
      inherit system;
      work = false;
      hostname = "dev";
      username = "denbeigh";
      graphical = false;
      keys = null;
    };

    pkgs = import nixpkgs { inherit overlays system; };
  };
in

{
  # TODO: Needs to be more generael
  system = "x86_64-linux";
  modules =  [
    home-manager.nixosModules.home-manager

    ../modules/denbeigh.nix
    ../modules/flakes.nix
    ../modules/cloud
    ../modules/cloud/aws

    {
      nixpkgs.overlays = overlays;
    }

    {
      networking = {
        hostName = "dev";
        domain = "denbeigh.cloud";
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        extraSpecialArgs = hostArgs;
        users.denbeigh = import ../../home-manager/home.nix (inputs // hostArgs);
      };

      system.stateVersion = "22.05";
    }
  ];
  specialArgs = inputs;
}
