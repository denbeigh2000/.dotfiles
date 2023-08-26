{
  config = {
    system = "aarch64-linux";
    modules = [
      ({ self, ... }:
        {
          imports = [
            ../../modules/nixos/standard.nix
            ../../modules/nixos/cloud
            ../../modules/nixos/cloud/aws-aarch64
          ];
          config = {
            denbeigh.machine.hostname = "plain";
            denbeigh.user.enable = false;
          };
        })
    ];
  };
}
