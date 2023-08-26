{
  system = "aarch64-darwin";
  modules = [
    { self, ... }:
    {
      imports = with self.nixosModules; [
        standard
        tailscale
      ];

      config.denbeigh = {
        machine = {
          hostname = "lucifer";
          # travelling
          location = self.lib.locations.milwaukee;
        };
        user = {
          username = "denbeigh";
          keys = [ "id_ed25519" ];
        };
      };
    }
  ];
}
