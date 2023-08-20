{ self, config, pkgs, ... }:

{
  imports = [
    ./secrets.nix
    self.inputs.fonts.nixosModules.update-tool
  ];

  config = let
    user = "font-updater";
  in {
    nixpkgs.overlays = [ self.inputs.agenix.overlays.default ];

    age.secrets.fontDeployKey = {
      file = ../../secrets/fontDeployKey.age;
      owner = user;
      mode = "600";
    };

    denbeigh.services.updaters.fonts = {
      enable = true;
      sshKeyPath = config.age.secrets.fontDeployKey.path;
      inherit user;
    };
  };
}
