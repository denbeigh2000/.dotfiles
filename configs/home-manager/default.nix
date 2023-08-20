{ self
, nixpkgs
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
  inherit (self.lib) loadDir;
  inherit (nixpkgs.lib) recursiveUpdate;

  hosts = loadDir ./.;
in
mapAttrs
  (_: host: (
    let
      inherit (host) system config;
      inherit (pkgs.stdenv.hostPlatform) isDarwin;
      inherit (pkgs.lib) setPrio;

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

      # Ensure we avoid conflicting with any work-provided packages
      priority = if config.denbeigh.work then 10 else 5;
    in
    setPrio priority (home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Pass flake inputs, host config to modules
      extraSpecialArgs = { inherit self; };

      modules = [
        ../../modules/home-manager
        (recursiveUpdate config {
          denbeigh.isNixOS = false;
        })
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    })
  ))
  hosts
