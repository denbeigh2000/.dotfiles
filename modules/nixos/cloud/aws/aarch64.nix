{ modulesPath, ... }:

{
  imports = [ ./. ];
  ec2.efi = true;
  nixpkgs.hostPlatform = "aarch64-linux";
}
