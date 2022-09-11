{ nixpkgs, denbeigh-devtools, home-manager, ... }@inputs:

let
  inherit (builtins) mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;

  configs = {
    coder-ec2-x86 = ./coder-ec2-x86.nix;
  };

in
  mapAttrs (_: modules: nixosSystem {
    # TODO: Needs to be more generael
    system = "x86_64-linux";
    modules =  [
      {
        nixpkgs.overlays = [
          denbeigh-devtools.overlay
        ];
      }
      home-manager.nixosModules.home-manager
    ] ++ (import modules);
    specialArgs = inputs;
  }) configs
