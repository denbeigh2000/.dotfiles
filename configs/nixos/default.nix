{ self }:

let
  inherit (builtins) mapAttrs path pathExists;

  defaults = ({ self, lib, ... }: {
    nixpkgs.overlays = [
      self.inputs.fonts.overlays.default
      self.overlays.unstable-pkgs
    ];
  });

  hwModule = name:
    let
      hwPath = ./hardware/${name}.nix;
    in
    if (pathExists hwPath) then (import hwPath) else { };

  buildConfig = name: cfg:
    let
      inherit (self.inputs.nixpkgs.lib) recursiveUpdate;
      config = recursiveUpdate cfg { host.isNixOS = true; };
      hostConfig = config.config;

      oldModules = if hostConfig ? modules then hostConfig.modules else [ ];
      modules = oldModules ++ [ defaults (hwModule name) ];
    in
    (hostConfig // {
      inherit modules;
      specialArgs = { inherit self; };
    });

in
mapAttrs buildConfig (self.lib.loadDir ./.)
