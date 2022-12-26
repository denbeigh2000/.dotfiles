{
  # General config to pass to nixosSystem
  config = {
    system = "aarch64-linux";
    modules = [
      ../modules/standard.nix
      ../modules/cloud/aws/aarch64.nix
      {
        denbeigh.machine.hostname = "dev";
      }
    ];
  };
}
