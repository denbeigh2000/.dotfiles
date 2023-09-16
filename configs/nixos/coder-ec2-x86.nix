{
  system = "x86_64-linux";
  config = {
    modules = [
      ({ self, ... }:
        {
          imports = [
            ../../modules/nixos/standard.nix
            ../../modules/nixos/cloud/aws
            ../../modules/nixos/cloud
            ../../modules/nixos/cloud/coder
          ];
          config = {
            denbeigh.machine.hostname = "dev";
          };
        })
    ];
  };
}
