{ config, lib, pkgs, agenix, denbeigh-devtools, fonts, ... }@inputs:

{
  imports = [ ../common/denbeigh.nix ];
  config = {
    nixpkgs.overlays = [
      agenix.overlays.default
      denbeigh-devtools.overlays.default
      fonts.overlays.default
    ];

    home-manager.extraSpecialArgs = {
      inherit (inputs) agenix denbeigh-devtools fonts nixgl;
    };
  };
}
