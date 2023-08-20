{
  config = {
    system = "aarch64-linux";
    modules = [
      ({ self, ... }:
        {
          imports = with self.nixosModules; [ standard cloud aws-aarch64 ];
          config = {
            denbeigh.machine.hostname = "plain";
            denbeigh.user.enable = false;
          };
        })
    ];
  };
}
