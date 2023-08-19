{
  system = "x86_64-linux";
  config = {
    modules = [
      ../../modules/nixos/standard.nix
      ../../modules/nixos/cloud/aws
      ../../modules/nixos/cloud
      {
        denbeigh.machine.hostname = "dev";
      }
    ];
  };
}
