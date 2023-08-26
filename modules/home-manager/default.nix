let
  inherit (builtins) mapAttrs;

  paths = {
    dev = ./dev.nix;
    git = ./git.nix;
    htop = ./htop.nix;
    zsh = ./zsh;
    linux = ./linux.nix;
    graphical = ./graphical.nix;
    scripts = ./scripts.nix;
    standard = ./standard.nix;
    use-nix-cache = ./use-nix-cache.nix;
    webcam = ./webcam.nix;
  };
in
mapAttrs (_: path: import path) paths
