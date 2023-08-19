{
  # General config to pass to nixosSystem
  config = {
    system = "aarch64-linux";
    modules = [
      ../../modules/nixos/standard.nix
      ../../modules/nixos/cloud/aws/aarch64.nix
      {
        denbeigh.machine.hostname = "dev";
      }
    ];
  };
}
