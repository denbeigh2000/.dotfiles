{ config, lib, pkgs, ... }:

{
  imports = [ ../common/denbeigh.nix ];
  config = {
    nixpkgs.overlays = [
      self.inputs.agenix.overlays.default
      self.inputs.denbeigh-devtools.overlays.default
      self.inputs.fonts.overlays.default
    ];

    home-manager.extraSpecialArgs = {
      inherit (self.inputs) agenix denbeigh-devtools fonts nixgl;
    };
  };
}
