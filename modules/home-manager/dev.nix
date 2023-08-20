{ self, config, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs.devPackages) python rust go node nix;

  inherit (config.denbeigh) work;

  python-packages = if !work then [ python.python310 ] else [ ];
  go-packages = if !work then go.all else [ go.gopls ];
  extra-node-packages = if !work then [ node.yarn ] else [ ];
  node-packages = if !work then node.allNode18 ++ extra-node-packages else [];
  nix-packages = [ nix.rnix-lsp ];
in

{
  home.packages = with pkgs; [ agenix neovim ctags direnv ]
    ++ rust.all
    ++ go-packages
    ++ node-packages
    ++ python-packages
    ++ nix-packages;
}
