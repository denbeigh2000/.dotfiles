{ denbeigh-devtools, host, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs.devPackages) python rust go node nix;

  inherit (host) work;

  python-packages = if !work then [ python.python310 ] else [ ];
  go-packages = if !work then go.all else [ go.gopls ];
  extra-node-packages = if !work then [ node.yarn ] else [ ];
  node-packages = node.allNode18 ++ extra-node-packages;
  nix-packages = [ nix.rnix-lsp ];
in

{
  nixpkgs.overlays = [
    denbeigh-devtools.overlay
  ];

  home.packages = [ pkgs.neovim ]
    ++ rust.all
    ++ go-packages
    ++ node-packages
    ++ python-packages
    ++ nix-packages;
}
