{
  system = "aarch64-darwin";
  modules = [
    ({ self, ... }:
      {
        imports = with self.darwinModules; [
          standard
          tailscale
        ];

        config.denbeigh = {
          machine = {
            hostname = "lucifer";
            location = self.lib.locations.sf;
          };
          user = {
            username = "denbeigh";
            keys = [ "id_ed25519" ];
          };
        };
      })
  ];
}
