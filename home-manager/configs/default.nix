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
  hosts = mapAttrs
    (n: v: v // { isNixOS = false; })
    (import ./hosts.nix);
in
mapAttrs
  (_: host: (
    let
      inherit (host) system username;
      pkgs = import nixpkgs {
        inherit (host) system;
        overlays = [ denbeigh-devtools.overlays.default nixgl.overlay ];
      };
      inherit (pkgs.stdenv.hostPlatform) isDarwin;
      homeDirectory = (
        if isDarwin
        then "/Users/${username}"
        else "/home/${username}"
      );
      inherit (pkgs.lib.debug) traceVal;
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Pass flake inputs, host config to modules
      extraSpecialArgs = inputs // { inherit host; };

      modules = [
        ../home.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    }
  ))
  hosts
