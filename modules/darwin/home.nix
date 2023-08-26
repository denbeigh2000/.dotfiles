{ config, lib, pkgs, ... }:

{
  imports = [
    self.inputs.home-manager.darwinModules.home-manager
    ../common/denbeigh.nix
  ];
  config = {
    home-manager.extraSpecialArgs = { inherit self; };
  };
}
