{
  # General config to pass to nixosSystem
  config = {
    system = "aarch64-linux";
    modules = [
      ({ self, ... }:
        {
          imports = [
            ../../modules/nixos/standard.nix
            ../../modules/nixos/cloud/aws/aarch64.nix
            ../../modules/nixos/cloud/coder
          ];
          config = {
            denbeigh.machine.hostname = "dev";
            system.stateVersion = "23.05";
          };
        })
    ];
  };
}
