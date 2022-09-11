{ nixpkgs, ... }@inputs:

let
  inherit (builtins) mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;

  configs = {
    coder-ec2-x86 = import ./coder-ec2-x86.nix;
  };
in
mapAttrs (_: module: nixosSystem (module inputs)) configs
