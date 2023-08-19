{ nixpkgs, nixpkgs-unstable, nixos-generators, fonts, ... }@inputs:

let
  localLib = import ../../lib {
    inherit (nixpkgs) lib;
  };

  inherit (builtins) mapAttrs path pathExists;
  inherit (localLib) loadDir;

  configs = loadDir ./.;

  defaults = { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
      attrs = inputs // { inherit pkgs-unstable; };
    in
    {
      nixpkgs.overlays = [
        fonts.overlays.default
        ((import ../../unstable-overlay.nix) attrs)
      ];
      system.stateVersion = "22.05"; #  Did you read the comment?
    };

  hwModule = name:
    let
      hwPath = ./hardware/${name}.nix;
    in
    if (pathExists hwPath) then (import hwPath) else { };

  buildConfig = name: cfg:
    let
      inherit (nixpkgs.lib) nixosSystem recursiveUpdate;
      config = recursiveUpdate cfg { host.isNixOS = true; };
      hostConfig = config.config;

      oldModules = if hostConfig ? modules then hostConfig.modules else [ ]; 
      modules = oldModules ++ [ defaults (hwModule name) ];

    in

    (hostConfig // {
      inherit modules;
      specialArgs = inputs;
    });

in
mapAttrs buildConfig configs
