{ pkgs, system, work }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs.devPackages) python rust go node nix;

  python-packages = if !work then [ python.python310 ] else [ ];

  extra-node-packages = if !work then [ node.yarn ] else [ ];
  node-packages = node.allNode18 ++ extra-node-packages;
  nix-packages = [ nix.rnix-lsp ];
in
rust.all ++ go.all ++ node-packages ++ python-packages ++ nix-packages
