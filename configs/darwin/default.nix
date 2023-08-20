{ self, nixpkgs, nixpkgs-unstable, darwin, home-manager, nix-upload-daemon, ... }@inputs:

let
  localLib = import ../../lib { inherit (nixpkgs) lib; };
  inherit (nixpkgs.lib) mapAttrs;
  inherit (localLib) loadDir;

  hosts = loadDir ./.;

  buildConfig = _: cfg:
    let
      inherit (darwin.lib) darwinSystem;
      extraModules = [
        { nixpkgs.overlays = [ self.overlays.unstable-pkgs ]; }
        home-manager.darwinModules.home-manager
      ];

      modules = extraModules ++ cfg.modules;
    in
    darwinSystem (cfg // {
      inherit modules;

      specialArgs = {
        inherit (inputs) denbeigh-devtools agenix fonts nixgl nix-upload-daemon;
      };
    });
in
mapAttrs buildConfig hosts
