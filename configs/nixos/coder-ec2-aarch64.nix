{
  # General config to pass to nixosSystem
  config = {
    system = "aarch64-linux";
    modules = [
      ({ self, ... }:
        {
          imports = with self.nixosModules; [ standard aws-aarch64 ];
          config = {
            denbeigh.machine.hostname = "dev";
          };
        })
    ];
  };
}
