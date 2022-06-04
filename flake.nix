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
      hosts = import ./hosts.nix;
      buildConfig = import ./build-home-config.nix;
    in
    {
      homeConfigurations = builtins.mapAttrs (name: host: (buildConfig {
        inherit nixpkgs home-manager neovim nixgl rnix-lsp host;
      })) hosts;
    };
}
