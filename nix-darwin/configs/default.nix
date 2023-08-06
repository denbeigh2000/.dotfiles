{ nixpkgs, nixpkgs-unstable, darwin, home-manager, upload-daemon, ... }@inputs:

let
  localLib = import ../../lib { inherit (nixpkgs) lib; };
  inherit (nixpkgs.lib) mapAttrs;
  inherit (localLib) loadDir;

  unstable-overlay = system:
    let
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
    in
    import ../../unstable-overlay.nix (inputs // { inherit pkgs-unstable; });

  hosts = loadDir ./.;

  buildConfig = _: cfg:
    let
      inherit (darwin.lib) darwinSystem;
      overlay = unstable-overlay cfg.system;

      extraModules = [
        { nixpkgs.overlays = [ overlay ]; }
        home-manager.darwinModules.home-manager
      ];

      modules = extraModules ++ cfg.modules;
    in
    darwinSystem (cfg // {
      inherit modules;

      specialArgs = {
        inherit (inputs) denbeigh-devtools agenix fonts nixgl upload-daemon;
      };
    });
in
mapAttrs buildConfig hosts
