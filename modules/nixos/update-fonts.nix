{ config, pkgs, agenix, fonts, ... }:

{
  imports = [
    ./secrets.nix
    fonts.nixosModules.update-tool
  ];

  config = let
    user = "font-updater";
  in {
    nixpkgs.overlays = [ agenix.overlays.default ];

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
