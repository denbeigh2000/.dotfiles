{
  description = "Denbeigh's Home Manager configuration";

  inputs = {
    # TODO: If we can backport delve running on more platforms to 22.05, we can
    # undo this
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-release.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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

    terraform-providers-bin = {
      url = "github:nix-community/nixpkgs-terraform-providers-bin";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-release
    , nixpkgs-unstable
    , home-manager
    , flake-utils
    , agenix
    , terraform-providers-bin
    , ...
    }@attrs:
    {
      homeConfigurations = import ./home-manager/configs attrs;
      nixosConfigurations = import ./nixos/configs attrs;
      nixosModules = import ./nixos/modules;
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          agenix.overlay
          (next: prev: {
            # These are very far apart, and have large feature gaps
            inherit (pkgs-unstable) radarr sonarr prowlarr;
            # This is only built for aarch64-linux in unstable
            inherit (pkgs-unstable) delve;
          })
        ];
      };
      tf-providers = import terraform-providers-bin { inherit system; };
      secret-tools = import ./tools/secrets { inherit pkgs; };
      ci-tools = import ./tools/ci { inherit pkgs; };
      terraform = import ./terraform { inherit pkgs tf-providers; };

      mkFlake = (import ./. { inherit pkgs flake-utils; });
    in
    mkFlake {
      packages = {
        ci = ci-tools.ci;
        inherit (terraform.packages) terraform terraform-config;
        inherit secret-tools;
      };
      apps.ci = {
        name = "ci";
        type = "app";
        program = "${ci-tools.ci}/bin/ci";
      };
      devShells = {
        default = pkgs.mkShell {
          name = "dotfiles-dev-shell";
          packages = [
            agenix.packages.${system}.agenix
            home-manager.packages.${system}.default
            secret-tools
          ];
        };
        ci = ci-tools.devShell;
        terraform = terraform.devShell;
      };
    }
    );
}
