{ ... }:

{
  system = "x86_64-darwin";
  modules = [
    {
      imports = [ ../modules/standard.nix ];
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
    }
  ];
}

