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
  inherit (nixpkgs.lib) recursiveUpdate;

  hosts = import ./hosts.nix;
in
mapAttrs
  (_: host: (
    let
      inherit (host) system config;
      inherit (pkgs.stdenv.hostPlatform) isDarwin;

      pkgs = import nixpkgs {
        inherit (host) system;
        overlays = [ denbeigh-devtools.overlays.default nixgl.overlay ];
      };

      # NOTE: This is manually tied to the same default as options.denbeigh.username
      username =
        if config.denbeigh ? username
        then config.denbeigh.username
        else "denbeigh";

      homeDirectory = (
        if isDarwin
        then "/Users/${username}"
        else "/home/${username}"
      );
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Pass flake inputs, host config to modules
      extraSpecialArgs = inputs;

      modules = [
        ../modules/default.nix
        (recursiveUpdate config {
          denbeigh.isNixOS = false;
        })
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    }
  ))
  hosts
