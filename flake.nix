{
  description = "Denbeigh's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
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
      inputs.flake-utils.follows = "flake-utils";
    };

    denbeigh-devtools = {
      url = "github:denbeigh2000/nix-dev";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    denbeigh-neovim = {
      url = "github:denbeigh2000/neovim-nix/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    terraform-providers-bin = {
      # pinned to commit to avoid major upgrades between applies
      url = "github:nix-community/nixpkgs-terraform-providers-bin/3d9d667c5f669d4b93a86a42650aa78d06df16d5";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-upload-daemon = {
      url = "github:denbeigh2000/nix-upload-daemon";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    noisetorch-src = {
      url = "ssh://git@github.com/noisetorch/NoiseTorch.git";
      flake = false;
      submodules = true;
      type = "git";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , flake-utils
    , agenix
    , fonts
    , terraform-providers-bin
    , nixos-generators
    , ...
    }@inputs:
    let
      inherit (builtins) mapAttrs;
      inherit (nixpkgs.lib) nixosSystem mapAttrs';
      inherit (nixos-generators) nixosGenerate;
      nixosSystemConfigs = import ./configs/nixos { inherit self; };
      nixosConfigurations = mapAttrs (_: cfg: nixosSystem cfg) nixosSystemConfigs;

      buildVm =
        (configName: config: {
          name = "vm-${configName}";
          value = nixosGenerate (config // {
            system = "x86_64-linux";
            format = "vm";
          });
        });


      vms = mapAttrs' buildVm nixosSystemConfigs;
      liveusb = nixosGenerate (nixosSystemConfigs.live // {
        system = "x86_64-linux";
        format = "iso";
        specialArgs = inputs;
      });

      unstable-overlay = (import ./unstable-overlay.nix {
        inherit (inputs) nixpkgs-unstable noisetorch-src;
      });
    in
    {
      lib = import ./lib { inherit (nixpkgs) lib; };

      inherit nixosConfigurations;
      darwinConfigurations = import ./configs/darwin inputs;
      homeConfigurations = import ./configs/home-manager inputs;

      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      overlays.unstable-pkgs = unstable-overlay;
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          agenix.overlays.default
          fonts.overlays.default
          unstable-overlay
        ];
      };
      tf-providers = import terraform-providers-bin { inherit system; };
      secret-tools = import ./tools/secrets { inherit pkgs; };
      terraform = import ./terraform { inherit pkgs tf-providers; };

      mkFlake = (import ./. { inherit pkgs flake-utils; });
    in
    mkFlake {
      packages = {
        inherit (terraform.packages) terraform terraform-config;
        inherit liveusb;
        inherit secret-tools;
      } // vms;
      devShells = {
        default = pkgs.mkShell {
          name = "dotfiles-dev-shell";
          packages = [
            pkgs.age
            pkgs.agenix
            home-manager.packages.${system}.default
            secret-tools
          ];
        };
        terraform = terraform.devShell;
      };
    }
    );
}
