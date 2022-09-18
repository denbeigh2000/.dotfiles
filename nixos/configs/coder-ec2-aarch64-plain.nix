{ ... }@inputs:

let
  system = "aarch64-linux";
  host = {
    inherit system;
    work = true;
    hostname = "plain";
    username = "denbeigh";
    graphical = false;
  };

  specialArgs = inputs // { inherit host; };
in
{
  inherit system specialArgs;
  modules = [
    home-manager.nixosModules.home-manager

    ../modules/standard.nix
    ../modules/cloud/aws/coder
    ../modules/cloud/aws/aarch64.nix
    {
      system.stateVersion = "22.05";
    }
  ];
}

