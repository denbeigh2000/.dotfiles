(import ./lib).mkConfig {
  system = "x86_64-linux";
  work = true;

  modules = [
    ({ self, pkgs, ... }:

      {
        imports = [ self.homeManagerModules.standard ];
        config.denbeigh = {
          work = true;
          hostname = "santiago";
          graphical = true;
          keys = [ "id_ed25519" ];
          location = self.lib.locations.sf;
        };
      })
  ];
}
