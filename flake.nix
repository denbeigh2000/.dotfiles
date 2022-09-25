{
  description = "Denbeigh's Home Manager configuration";

  inputs = {
    # TODO: If we can backport delve running on more platforms to 22.05, we can
    # undo this
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix/0.12.0";
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
    , agenix
    , ...
    }@attrs:
    {
      homeConfigurations = import ./home-manager/configs attrs;
      nixosConfigurations = import ./nixos/configs attrs;
      nixosModules = import ./nixos/modules;
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ agenix.overlay ];
      };
      tools = import ./tools { inherit pkgs; };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          agenix.packages.${system}.agenix
          home-manager.packages.${system}.default
          tools
        ];
      };
    }
    );
}
