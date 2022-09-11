{ nixpkgs, ... }@inputs:

let
  inherit (builtins) mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;

  configs = {
    coder-ec2-x86 = ./coder-ec2-x86.nix;
  };
in
mapAttrs (_: path: nixosSystem (import path inputs)) configs
