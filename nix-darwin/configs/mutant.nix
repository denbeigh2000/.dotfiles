{
  system = "aarch64-darwin";
  modules = [
    ../modules/standard.nix
    ../modules/tailscale.nix
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
