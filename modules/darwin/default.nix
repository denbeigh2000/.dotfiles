let
  inherit (builtins) mapAttrs;

  paths = {
    standard = ./standard.nix;
    tailscale = ./tailscale.nix;

    graphical = ./graphical.nix;
    use-nix-cache = ./use-nix-cache.nix;
    home = ./home.nix;
    system-options = ./system-options.nix;
    upload-daemon = ./upload-daemon.nix;
  };

in
  mapAttrs (_: path: import path) paths
