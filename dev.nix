{ pkgs }:

let
  python-packages = packages: with packages; [
    pynvim
    python-lsp-server
    pylsp-mypy
    pyls-isort
    python-lsp-black
  ];

  python = pkgs.python310.withPackages python-packages;

  node-packages = with pkgs.nodePackages; [
    typescript-language-server
  ];

  allPackages = [ python ] ++
     (with pkgs; [ rustc cargo rustfmt rust-analyzer ]) ++
     (with pkgs; [ nodejs-18_x yarn ]) ++ node-packages;
in
  allPackages
