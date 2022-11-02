{ nixpkgs, nixpkgs-release, nixpkgs-unstable, ... }@inputs:

let
  inherit (builtins) mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;

  configs = {
    bruce = ./bruce.nix;
    coder-ec2-x86 = ./coder-ec2-x86.nix;
    coder-ec2-aarch64 = ./coder-ec2-aarch64.nix;
    coder-ec2-aarch64-plain = ./coder-ec2-aarch64-plain.nix;
  };

  defaults = { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
      pkgs-release = import nixpkgs-release { inherit system; };
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          # https://www.openssl.org/news/secadv/20221101.txt
          inherit (pkgs-release) openssl_3;
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
      modules = config.modules ++ [ defaults ];
      config = ((import configPath) inputs);
    in
    nixosSystem (config // { inherit modules; });

in
mapAttrs (_: config: (buildSystem config)) configs
