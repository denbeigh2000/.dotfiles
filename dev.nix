{ pkgs, system, work }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  pip-packages = packages:
    with packages; ([ pynvim ]) ++ (
      if system != "aarch64-darwin"
      then
        ([
          python-lsp-server
          pylsp-mypy
          pyls-isort
          python-lsp-black
        ]) else [ ]
    );

  python = pkgs.python310.withPackages pip-packages;

  node-packages = with pkgs.nodePackages; [
    typescript-language-server
  ];

  python-packages = if !work then [ python ] else [ ];

  extra-js-packafges = if !work then [ pkgs.yarn ] else [ ];
  js-packages = [ pkgs.nodejs-18_x ] ++ node-packages ++ extra-js-packafges;
in
  (with pkgs; [ rustc cargo rustfmt rust-analyzer ]) ++
  js-packages ++ python-packages
