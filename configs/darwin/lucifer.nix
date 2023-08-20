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
        };
        user = {
          username = "denbeigh";
          keys = [ "id_ed25519" ];
        };
      };
    }
  ];
}
