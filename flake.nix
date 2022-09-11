{
  description = "Denbeigh's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fonts = {
      url = "github:denbeigh2000/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    denbeigh-devtools = {
      url = "github:denbeigh2000/nix-dev";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , flake-utils
    , ...
    }@attrs:
    {
      homeConfigurations = import ./home-manager/configs attrs;
      nixosConfigurations = import ./nixos/configs attrs;
      nixosModules = import ./nixos/modules;
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [ home-manager.packages.${system}.default ];
      };
    }
    );
}
