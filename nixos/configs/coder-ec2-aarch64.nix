{ ... }@inputs:

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
    ../modules/standard.nix
    ../modules/cloud/aws/aarch64.nix
    ../modules/cloud/aws/coder
    {
      system.stateVersion = "22.05";
    }
  ];
}
