(import ./lib).mkConfig {
  system = "x86_64-linux";
  work = true;

  modules = [
    ({ self }:

      {
        imports = [ self.homeManagerModules.standard ];
        config.denbeigh = {
          username = "discord";
          hostname = "denbeigh";
          work = true;
        };
      })
  ];
}
