{
  system = "aarch64-darwin";
  modules = [
    {
      imports = [
        ../../modules/darwin/standard.nix
        ../../modules/darwin/tailscale.nix
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
