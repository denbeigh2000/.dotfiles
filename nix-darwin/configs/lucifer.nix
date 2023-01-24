{ ... }:

{
  system = "aarch64-darwin";
  modules = [
    {
      imports = [ ../modules/standard.nix ];
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
