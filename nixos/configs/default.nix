{ nixpkgs, ... }@inputs:

builtins.map (module: 
  nixpkgs.lib.nixosSystem (import module inports)
) [
  ./coder-ec2-x86.nix
]
