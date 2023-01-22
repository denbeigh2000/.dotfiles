{ nixpkgs, darwin, home-manager, ... }@inputs:

let
  localLib = import ../../lib { inherit (nixpkgs) lib; };
  inherit (nixpkgs.lib) mapAttrs;
  inherit (localLib) loadDir;

  hosts = loadDir ./.;

  buildConfig = _: cfg:
    let
      inherit (darwin.lib) darwinSystem;
      hostConfig = cfg inputs;
      modules = hostConfig.modules ++ [
        home-manager.darwinModules.home-manager
      ];
      attrs = hostConfig // {
        inherit modules;

        specialArgs = {
          inherit (inputs) denbeigh-devtools agenix fonts nixgl;
        };
      };
    in
    darwinSystem attrs;
in
mapAttrs buildConfig hosts
