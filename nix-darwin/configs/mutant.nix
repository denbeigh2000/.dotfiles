{ ... }@inputs:

let
  mod = name: ../modules/${name};
in
{
  system = "aarch64-darwin";
  modules = [
    {
      # imports = [ ../modules/home.nix ];
      # imports = [ home-manager.darwinModules.home-manager ];
      imports = [ ../modules/standard.nix ];
      config.denbeigh = {
        machine = {
          hostname = "mutant";
        };
        user = {
          username = "denbeighstevens";
          keys = [ "id_ed25519" ];
        };
      };
    }
  ];
}
