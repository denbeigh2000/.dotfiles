{ nixpkgs
, home-manager
, fonts
, denbeigh-devtools
, nixgl
, ...
}@inputs:

# Load non-NixOS home-manager configurations.
# NixOS home-manager configurations are loaded in nixos/configs/default.nix

let
  inherit (builtins) mapAttrs;
  inherit (nixpkgs.lib.attrs) recursiveUpdate;
in
mapAttrs
  (_: host: (
    let
      inherit (host) system config;
      pkgs = import nixpkgs {
        inherit (host) system;
        overlays = [ denbeigh-devtools.overlays.default nixgl.overlay ];
      };
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Pass flake inputs, host config to modules
      extraSpecialArgs = inputs;

      modules = [
        ../modules/default.nix
      ];

      users.${config.denbeigh.username} = recursiveUpdate config {
        denbeigh.isNixOS = false;
      };

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    }
  ))
  hosts
