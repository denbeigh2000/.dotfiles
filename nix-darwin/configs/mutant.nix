{ agenix, ... }:

{
  system = "aarch64-darwin";
  modules = [
    agenix.nixosModules.age
    ../modules/standard.nix
    ../modules/tailscale.nix
    {
      config = {
        denbeigh = {
          machine = {
            hostname = "mutant";
          };
          user = {
            username = "denbeighstevens";
            keys = [ "id_ed25519" ];
          };
        };

        # TODO: Use a more DRY setup for this
        age.identityPaths = [ "/var/lib/denbeigh/host_key" ];
      };
    }
  ];
}
