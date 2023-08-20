let
  inherit (builtins) mapAttrs;

  paths = {
    standard = ./standard.nix;
    tailscale = ./tailscale.nix;
  };

in
  mapAttrs (_: path: import path) paths
