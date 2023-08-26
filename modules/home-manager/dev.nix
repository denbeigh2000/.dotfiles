{ self, config, lib, pkgs, ... }:

{
  options =
    let
      inherit (lib) mkOption types;
      isWork = config.denbeigh.work;
    in
    {
      denbeigh.dev.languages = {
        go.enable = mkOption {
          description = "Install Golang build tools";
          type = types.bool;
          default = !isWork;
        };

        rust.enable = mkOption {
          description = "Install Rust build tools";
          type = types.bool;
          default = !isWork;
        };

        node.enable = mkOption {
          description = "Install NodeJS build tools";
          type = types.bool;
          default = !isWork;
        };

        python.enable = mkOption {
          description = "Install Python build tools";
          type = types.bool;
          default = !isWork;
        };
      };
    };

  config =
    let
      cfg = config.denbeigh.dev.languages;

      inherit (pkgs.devPackages) python rust go node;

      rust-pkgs = if cfg.rust.enable then rust.all else [ ];
      go-pkgs = if cfg.go.enable then go.all else [ ];
      node-pkgs = if cfg.node.enable then node.allNode18 ++ [ node.yarn ] else [ ];
      python-pkgs = if cfg.python.enable then [ python.python310 ] else [ ];
    in
    {
      nixpkgs.overlays = [
        self.inputs.agenix.overlays.default
        self.inputs.denbeigh-neovim.overlays.default
        self.inputs.denbeigh-devtools.overlays.default
      ];

      home.packages = with pkgs; [ agenix neovim ctags direnv ]
        ++ rust-pkgs
        ++ go-pkgs
        ++ node-pkgs
        ++ python-pkgs;
    };
}
