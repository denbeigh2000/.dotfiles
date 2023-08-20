{
  description = "Denbeigh's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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

    terraform-providers-bin = {
      url = "github:nix-community/nixpkgs-terraform-providers-bin";
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

    cfdyndns-src = {
      url = "github:denbeigh2000/cfdyndns";
      flake = false;
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
    , fonts
    , agenix
    , terraform-providers-bin
    , nixos-generators
    , ...
    }@inputs:
    let
      inherit (builtins) mapAttrs;
      inherit (nixpkgs.lib) nixosSystem mapAttrs';
      inherit (nixos-generators) nixosGenerate;
      nixosSystemConfigs = import ./configs/nixos inputs;
      nixosConfigurations = mapAttrs (_: cfg: nixosSystem cfg) nixosSystemConfigs;

      buildVm =
        (configName: config: {
          name = "vm-${configName}";
          value = nixosGenerate (config // {
            system = "x86_64-linux";
            format = "vm";
          });
        });

      nixosModules = import ./modules/nixos;

      # TODO: Why are these giving infinite recursion errors?
      # vms = mapAttrs' buildVm nixosSystemConfigs;
      # TODO: Fix this so that it works correctly when injecting nixosModules
      # liveusb = nixosGenerate ((nixosSystemConfigs.live nixosModules) // {
      #   system = "x86_64-linux";
      #   format = "iso";
      # });
    in
    {
      inherit nixosConfigurations nixosModules;
      darwinConfigurations = import ./configs/darwin inputs;
      homeConfigurations = import ./configs/home-manager inputs;
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          agenix.overlays.default
          fonts.overlays.default
          (import ./unstable-overlay.nix (inputs // { inherit pkgs-unstable; }))
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
        # inherit liveusb;
        inherit secret-tools;
      };
      devShells = {
        default = pkgs.mkShell {
          name = "dotfiles-dev-shell";
          packages = [
            pkgs.age
            agenix.packages.${system}.agenix
            home-manager.packages.${system}.default
            secret-tools
          ];
        };
        terraform = terraform.devShell;
      };
    }
    );
}
