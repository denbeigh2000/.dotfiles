{
  config = {
    modules = [
      ({ self, ... }:
        {
          imports = [
            ../../modules/nixos/standard.nix
            ../../modules/nixos/development.nix
          ];
          config = {
            nixpkgs.hostPlatform = "x86_64-linux";
            system.stateVersion = "23.05";
            boot.loader.systemd-boot.enable = true;

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

