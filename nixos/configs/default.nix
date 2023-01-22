{ nixpkgs, nixpkgs-unstable, nixos-generators, fonts, ... }@inputs:

let
  localLib = import ../../lib {
    inherit (nixpkgs) lib;
  };

  inherit (builtins) mapAttrs path;
  inherit (localLib) loadDir;

  configs = loadDir ./.;

  defaults = { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
    in
    {
      nixpkgs.overlays = [
        fonts.overlays.default
        (import ../../unstable-overlay.nix { inherit pkgs-unstable; })
      ];
      system.stateVersion = "22.05"; #  Did you read the comment?
    };

  buildConfig = cfg:
    let
      inherit (nixpkgs.lib) nixosSystem recursiveUpdate;
      config = recursiveUpdate cfg { host.isNixOS = true; };
      hostConfig = config.config;

      modules = (if hostConfig ? modules then hostConfig.modules else [ ]) ++ [ defaults ];
    in

    (hostConfig // {
      inherit modules;
      specialArgs = inputs;
    });

in
mapAttrs (_: config: (buildConfig config)) configs
