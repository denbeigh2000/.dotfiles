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

    denbeigh-ci = {
      url = "github:denbeigh2000/ci";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
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
    , denbeigh-ci
    , ...
    }@inputs:
    let
      inherit (builtins) mapAttrs;
      inherit (nixpkgs.lib) filterAttrs optionalAttrs mapAttrs' nixosSystem;
      inherit (nixos-generators) nixosGenerate;
      nixosSystemConfigs = import ./configs/nixos { inherit self; };
      nixosConfigurations = mapAttrs (_: cfg: nixosSystem cfg) nixosSystemConfigs;

      buildVm = (configName: config: {
        name = "vm-${configName}";
        value = nixosGenerate (config // {
          system = "x86_64-linux";
          format = "vm";
        });
      });

      # NOTE: Filtering this down to just a few configurations I care about.
      # Otherwise it gets kind of long to build mostly the same thing (and also
      # becomes hard to know which arch to build for)
      # vms = mapAttrs' buildVm nixosSystemConfigs;
      vms = mapAttrs' buildVm {
        inherit (nixosSystemConfigs) bruce martha;
      };
      buildLiveUsb = system: nixosGenerate (nixosSystemConfigs.live // {
        inherit system;
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
      scripts = pkgs.callPackage ./scripts { };
      secret-tools = import ./tools/secrets { inherit pkgs; };
      terraform = import ./terraform { inherit pkgs tf-providers; };
    in
    {
      ci = denbeigh-ci.lib.mkCIConfig { inherit self pkgs; };
      packages = ({
        # NOTE: avoiding terraform stuff until i address the terraform unfree
        # licensing snafu
        # inherit (terraform.packages) terraform terraform-config;
        inherit secret-tools;
        inherit (scripts) gitignore roulette;
        ci-tool = denbeigh-ci.packages.${system}.tool;
      }
      // (optionalAttrs (system == "x86_64-linux") vms)
      // (optionalAttrs (pkgs.stdenvNoCC.targetPlatform.isLinux) { liveusb = buildLiveUsb system; }));
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
        # terraform = terraform.devShell;
      };
    }
    );
}
