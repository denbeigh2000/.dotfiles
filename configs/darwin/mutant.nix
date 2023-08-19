{
  system = "aarch64-darwin";
  modules = [
    ../../modules/darwin/standard.nix
    ../../modules/darwin/tailscale.nix
    {
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
      };
    }
  ];
}
