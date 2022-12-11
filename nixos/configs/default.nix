{ nixpkgs, nixpkgs-unstable, ... }@inputs:

let
  inherit (builtins) mapAttrs;

  configs =
    let
      inherit (builtins) path readDir stringLength substring;
      inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs';
      inherit (nixpkgs.lib.strings) hasSuffix;

      pwd = path { path = ./.; name = "config-pwd"; };
      isModule = (n: v:
        n != "default.nix" && v == "regular" && (hasSuffix ".nix" n));

      modules = filterAttrs isModule (readDir pwd);
      toConfig = filename: _:
        let
          name = substring 0 ((stringLength filename) - 4) filename;
        in
        { inherit name; value = ./${filename}; };
    in
    mapAttrs' toConfig modules;

  defaults = { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          # These are very far apart, and have large feature gaps
          inherit (pkgs-unstable) radarr sonarr prowlarr;
          # This is only built for aarch64-linux in unstable
          inherit (pkgs-unstable) delve;
        })
      ];
      system.stateVersion = "22.05"; #  Did you read the comment?
    };

  buildSystem = configPath:
    let
      inherit (builtins) pathExists;
      inherit (nixpkgs.lib) nixosSystem;
      config = import configPath;
      hostConfig = config.config;

      hardware =
        let
          hwPath = ./hardware/${config.host.hostname}.nix;
        in
        if (pathExists hwPath) then (import hwPath) else { };

      specialArgs = inputs // { inherit (config) host; };
      modules = (if hostConfig ? modules then hostConfig.modules else []) ++ [ defaults hardware ];
    in
    nixosSystem (hostConfig // {
      inherit modules specialArgs;
      inherit (config.host) system;
    });

in
mapAttrs (_: config: (buildSystem config)) configs
