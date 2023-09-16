{
  # General config to pass to nixosSystem
  config = {
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
          };
        })
    ];
  };
}
