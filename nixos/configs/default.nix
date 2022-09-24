{ nixpkgs, ... }@inputs:

let
  inherit (builtins) mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;

  configs = {
    bruce = ./bruce.nix;
    coder-ec2-x86 = ./coder-ec2-x86.nix;
    coder-ec2-aarch64 = ./coder-ec2-aarch64.nix;
    coder-ec2-aarch64-plain = ./coder-ec2-aarch64-plain.nix;
  };

in
  mapAttrs (_: config: nixosSystem (import config inputs)) configs
