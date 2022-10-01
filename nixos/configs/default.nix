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

  defaults = {
    system.stateVersion = "22.05"; #  Did you read the comment?
  };

  buildSystem = configPath:
    let
      modules = config.modules ++ [defaults];
      config = ((import configPath) inputs);
    in
    nixosSystem (config // { inherit modules; });

in
mapAttrs (_: config: (buildSystem config)) configs
