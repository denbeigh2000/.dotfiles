{ nixpkgs, home-manager, fonts, neovim, nixgl, rnix-lsp, host }:
let
  inherit (host) system username;
  pkgs = import nixpkgs { inherit (host) system; };
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

  configuration = import ./home.nix {
    inherit pkgs host system fonts;

    neovim = neovim.defaultPackage."${system}";
    rnix-lsp = rnix-lsp.defaultPackage."${system}";
    nixgl = nixgl.defaultPackage.x86_64-linux;
  };

  # Update the state version as needed.
  # See the changelog here:
  # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
  stateVersion = "22.05";

  # Optionally use extraSpecialArgs
  # to pass through arguments to home.nix
}
