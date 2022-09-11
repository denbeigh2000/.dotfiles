{ nixpkgs
, home-manager
, fonts
, denbeigh-devtools
, hosts
, ...
}@inputs:

builtins.mapAttrs
  (_: host: (
    let
      inherit (host) system username;
      pkgs = import nixpkgs {
        inherit (host) system;
        overlays = [ denbeigh-devtools.overlay ];
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
      inherit system username homeDirectory;

      # Pass flake inputs, host config to modules
      extraSpecialArgs = inputs // { inherit host; };
      configuration = import ./home.nix {
        inherit pkgs host system fonts;
      };

      # Update the state version as needed.
      # See the changelog here:
      # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
      stateVersion = "22.05";

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    }
  ))
  hosts
