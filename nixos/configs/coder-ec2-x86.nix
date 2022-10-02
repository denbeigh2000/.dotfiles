{ ... }@inputs:

let
  system = "x86_64-linux";
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
    ../modules/cloud
    ../modules/cloud/aws
  ];
}
