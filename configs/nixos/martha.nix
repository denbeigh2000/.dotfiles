{
  config = {
    system = "x86_64-linux";
    modules = [
      ({ self, ... }:
        {
          imports = [
            ../../modules/nixos/standard.nix
            ../../modules/nixos/development.nix
          ];
          config = {
            boot.loader.grub = {
              enable = true;
              device = "/dev/sda";
            };

            denbeigh = {
              machine = {
                hostname = "martha";
                graphical = true;
                location = self.lib.locations.sf;
              };
            };

            # TODO: Use a more DRY setup for this
            age.identityPaths = [ "/home/denbeigh/.ssh/id_rsa" ];
          };
        })
    ];
  };
}

