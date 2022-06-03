{
  description = "Denbeigh's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Make this public
    neovim = {
      url = "git+ssh://git@github.com/denbeigh2000/neovim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, home-manager, neovim, flake-utils, nixgl, rnix-lsp }:
    let
      buildConfig = { hostname, system, username, homeDirectory }:
        home-manager.lib.homeManagerConfiguration {
          inherit system username homeDirectory;

          configuration = import ./home.nix {
            inherit hostname;

            pkgs = nixpkgs.legacyPackages."${system}";
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
        };

    in
    {
      homeConfigurations.martha = buildConfig {
        hostname = "martha";
        system = "x86_64-linux";
        homeDirectory = "/home/denbeigh";
        username = "denbeigh";
      };
      homeConfigurations.mutant = buildConfig {
        hostname = "mutant";
        system = "aarch64-darwin";
        homeDirectory = "/Users/denbeigh.stevens";
        username = "denbeigh.stevens";
      };
    };
}
