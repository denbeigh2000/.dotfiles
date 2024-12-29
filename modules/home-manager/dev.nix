{ self, config, lib, pkgs, ... }:

{
  options =
    let
      inherit (lib) mkOption types;

      cfg = config.denbeigh.dev;
    in
    {
      denbeigh.dev = {
        enable = mkOption {
          description = "Whether to manage the default set of build tools";
          type = types.bool;
          default = !config.denbeigh.work;
        };
        languages = {
          go.enable = mkOption {
            description = "Install Golang build tools";
            type = types.bool;
            default = cfg.enable;
          };

          rust.enable = mkOption {
            description = "Install Rust build tools";
            type = types.bool;
            default = cfg.enable;
          };

          node.enable = mkOption {
            description = "Install NodeJS build tools";
            type = types.bool;
            default = cfg.enable;
          };

          python.enable = mkOption {
            description = "Install Python build tools";
            type = types.bool;
            default = cfg.enable;
          };
        };
      };
    };

  config =
    let
      cfg = config.denbeigh.dev.languages;

      # inherit (pkgs.devPackages) python rust go node;
      inherit (pkgs) python313 go nodejs nodePackages rustc cargo;
      inherit (pkgs.lib) optionals;

      rust-pkgs = optionals cfg.rust.enable (with pkgs; [ rustc cargo ]);
      go-pkgs = optionals cfg.go.enable [ go ];
      node-pkgs = optionals cfg.node.enable [ nodejs nodePackages.yarn nodePackages.pnpm ];
      python-pkgs = optionals cfg.python.enable [ python313 ];
    in
    {
      nixpkgs.overlays = [
        self.inputs.agenix.overlays.default
        self.inputs.denbeigh-neovim.overlays.default
      ];

      home.packages = with pkgs; [ agenix neovim ctags direnv ]
        ++ rust-pkgs
        ++ go-pkgs
        ++ node-pkgs
        ++ python-pkgs;
    };
}
