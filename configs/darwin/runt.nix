{
  system = "x86_64-darwin";
  modules = [
    ({ self, ... }:
      {
        imports = [ self.darwinModules.standard ];
        config.denbeigh = {
          machine = {
            hostname = "runt";
            work = true;
          };
          user = {
            username = "denbeigh.stevens";
            keys = [ "id_ed25519" ];
          };
        };
      })
  ];
}

