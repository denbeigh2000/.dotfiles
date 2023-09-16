{
  config = {
    system = "x86_64-linux";
    modules = [
      ({ self, ... }:
        {
          imports = [
            ../../modules/nixos/standard.nix
            ../../modules/nixos/development.nix
            ../../modules/nixos/gaming.nix
          ];
          config = {
            boot.loader.grub = {
              enable = true;
              version = 2;
              device = "/dev/sda";
            };

            denbeigh = {
              machine = {
                hostname = "feliccia";
                graphical = true;
                location = self.lib.locations.sf;
              };

              webcam = {
                enable = true;
                # TODO: Confirm
                videoDevice = "/dev/video0";
              };
            };

            # TODO: Use a more DRY setup for this
            age.identityPaths = [ "/home/denbeigh/.ssh/id_rsa" ];
          };

          system.stateVersion = "22.05";
        })
    ];
  };
}
