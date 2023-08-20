{ self, nixpkgs, darwin, home-manager, ... }:
let
  localLib = import ../../lib { inherit (nixpkgs) lib; };
  inherit (nixpkgs.lib) mapAttrs;

  buildConfig = _: cfg:
    let
      inherit (darwin.lib) darwinSystem;
      extraModules = [
        { nixpkgs.overlays = [ self.overlays.unstable-pkgs ]; }
        home-manager.darwinModules.home-manager
      ];

    in
    darwinSystem (cfg // {
      modules = extraModules ++ cfg.modules;

      specialArgs = { inherit self; };
    });
in
mapAttrs buildConfig (self.lib.loadDir ./.)
