{ lib, ... }:

{
  imports = [
    ./base.nix
    ./use-nix-cache.nix
    ./home.nix
  ];
}
