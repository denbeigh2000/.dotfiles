(import ./lib).mkConfig {
  system = "x86_64-linux";

  modules = [
    ({ self, pkgs, ... }:
      {
        imports = [ self.homeManagerModules.standard ];
        config = {
          services.noisetorch.enable = false;
          denbeigh = {
            hostname = "martha";
            graphical = true;
            keys = [ "id_ed25519" ];
            location = self.lib.locations.sf;
          };
        };
      })
  ];
}
