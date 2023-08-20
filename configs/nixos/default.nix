{ self }:

let
  localLib = import ../../lib {
    inherit (self.inputs.nixpkgs) lib;
  };

  inherit (builtins) mapAttrs path pathExists;
  inherit (localLib) loadDir;

  configs = loadDir ./.;

  defaults = {
    nixpkgs.overlays = [
      self.inputs.fonts.overlays.default
      self.overlays.unstable-pkgs
    ];
    # TODO: Move this to system-specific files...so we can say we've actually
    # read the comment
    system.stateVersion = "22.05"; #  Did you read the comment?
  };

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
mapAttrs buildConfig configs
