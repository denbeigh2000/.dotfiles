{ self
, ...
}:

# Load non-NixOS home-manager configurations.
# NixOS home-manager configurations are loaded in nixos/configs/default.nix

let
  inherit (builtins) mapAttrs;
  inherit (self.lib) loadDir;

  hosts = loadDir ./.;
in
mapAttrs
  # NOTE: host is a function that takes self as a parameter, which
  # allows the non-NixOS home-manager config files to be imported
  # without args
  (_: host: (host self))
  hosts
