{ ... }:

{
  system = "aarch64-darwin";
  modules = [
    {
      imports = [ ../modules/standard.nix ];
      config.denbeigh = {
        machine = {
          hostname = "shoenice";
        };
        user = {
          username = "denbeigh";
          keys = [ "id_ed25519" ];
        };
      };
    }
  ];
}
