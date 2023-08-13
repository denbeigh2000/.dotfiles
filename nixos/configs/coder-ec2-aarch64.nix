{
  # General config to pass to nixosSystem
  config = {
    modules = [
      ../modules/standard.nix
      ../modules/cloud/aws/aarch64.nix
      {
        denbeigh.machine.hostname = "dev";
        nixpkgs.hostPlatform = "aarch64-linux";
      }
    ];
  };
}
