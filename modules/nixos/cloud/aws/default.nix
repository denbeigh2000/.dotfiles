{ modulesPath, lib, pkgs, ... }:

{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  ec2.hvm = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Install AWS CLI by default on AWS machines
  environment.systemPackages = [ pkgs.awscli2 ];
}
