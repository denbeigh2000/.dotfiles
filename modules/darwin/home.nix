{ config, lib, pkgs, ... }:

{
  imports = [ ../common/denbeigh.nix ];
  config = {
    nixpkgs.overlays = with self.inputs; [
      agenix.overlays.default
      denbeigh-devtools.overlays.default
      fonts.overlays.default
    ];

    home-manager.extraSpecialArgs = {
      inherit (self.inputs) agenix denbeigh-devtools fonts nixgl;
    };
  };
}
