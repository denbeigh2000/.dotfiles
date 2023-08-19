{
  config = {
    system = "aarch64-linux";
    modules = [
      ../../modules/nixos/standard.nix
      ../../modules/nixos/cloud/aws/aarch64.nix
      ../../modules/nixos/cloud
      {
        denbeigh.machine.hostname = "plain";
      }
    ];
  };
}
