{
  system = "aarch64-darwin";
  modules = [
    ({ self, ... }:
      {
        imports = with self.darwinModules; [
          standard
          tailscale
        ];
        config = {
          denbeigh = {
            nix-cache.enable = false;
            machine = {
              work = true;
              hostname = "mutant";
            };
            user = {
              username = "denbeighstevens";
              keys = [ "id_ed25519" ];
            };
          };

          system.stateVersion = 5;
        };
      })
  ];
}
