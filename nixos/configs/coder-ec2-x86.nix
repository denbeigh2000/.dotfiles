{ ... }:

{
  system = "x86_64-linux";

  modules = [
    ../modules/denbeigh.nix
    ../modules/cloud
    ../modules/cloud/aws
    {
      networking = {
        hostName = "dev";
        domain = "denbeigh.cloud";
      };

      hmConfig = "coder";
    }
  ];
}
