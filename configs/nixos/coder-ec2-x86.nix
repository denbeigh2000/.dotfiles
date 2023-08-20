{
  system = "x86_64-linux";
  config = {
    modules = [
      ({ self, ... }:
        {
          imports = with self.nixosModules; [ standard aws cloud ];
          config = {
            denbeigh.machine.hostname = "dev";
          };
        })
    ];
  };
}
