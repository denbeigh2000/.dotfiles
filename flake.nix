{
  description = "Denbeigh's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
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

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
    , fonts
    , agenix
    , terraform-providers-bin
    , nixos-generators
    , ...
    }@attrs:
    let
      inherit (builtins) mapAttrs;
      inherit (nixpkgs.lib) nixosSystem mapAttrs';
      inherit (nixos-generators) nixosGenerate;
      nixosSystemConfigs = import ./nixos/configs attrs;
      nixosConfigurations = mapAttrs
        (n: v: nixosSystem v)
        nixosSystemConfigs;

      hwModule = config:
        let
          hwPath = ./nixos/configs/hardware/${config.host.hostname}.nix;
        in
        if (pathExists hwPath) then (import hwPath) else { };

      patchHardware = config:
        let
          hardware = hwModule config;
          modules = (if config ? modules then config.modules else [ ]) ++ [ hardware ];
        in
        (config // { inherit modules; });

      buildSystem =
        (name: config: {
          inherit name;
          value =
              nixosSystem (patchHardware config);
        });

      buildVm =
        (configName: config: {
          name = "vm-${configName}";
          value = nixosGenerate (config // { format = "vm"; });
        });

      vms = mapAttrs' buildVm nixosSystemConfigs;
    in
    {
      inherit nixosConfigurations;
      homeConfigurations = import ./home-manager/configs attrs;
      nixosModules = import ./nixos/modules;
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          agenix.overlay
          fonts.overlays.default
          (next: prev: {
            # These are very far apart, and have large feature gaps
            inherit (pkgs-unstable) radarr sonarr prowlarr;
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
      } // vms;
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
