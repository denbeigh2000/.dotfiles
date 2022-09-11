{ nixpkgs, home-manager, ... }@inputs:

let
  inherit (builtins) mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;

  configs = {
    coder-ec2-x86 = ./coder-ec2-x86.nix;
  };

  attrs = inputs // {
    modules = inputs.modules ++ [
      home-manager.nixosModules.home-manager
    ];
  };
in
  mapAttrs (_: module: nixosSystem {
    modules = [ module ];
    specialArgs = inputs;
  }) configs
