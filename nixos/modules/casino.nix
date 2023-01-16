{ config, pkgs, agenix, csgotothecasino, fenix, ... }:

{
  imports = with csgotothecasino.nixosModules; [ casino viz ];

  config = {
    nixpkgs.overlays = [ agenix.overlay fenix.overlays.default csgotothecasino.overlays.default ];

    age.secrets.csgoFloatKey = {
      file = ../../secrets/csgoFloatKey.age;
      mode = "440";
      owner = "casino";
      group = "casino";
    };

    age.secrets.keystoreFile = {
      file = ../../secrets/casinoKeystore.age;
      mode = "440";
      owner = "casino";
      group = "casino";
    };

    users = {
      users.casino = {
        isSystemUser = true;
        uid = 6667;
        group = "casino";
      };
      groups.casino.gid = 6667;
    };

    casino = {
      frontend.enable = true;
      backend = {
        enable = true;
        csgoFloatKeyFile = config.age.secrets.csgoFloatKey.path;
        keystorePath = config.age.secrets.keystoreFile.path;
      };
    };
  };
}
