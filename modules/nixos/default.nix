let
  inherit (builtins) mapAttrs;

  paths = {
    ahoy = ./ahoy.nix;
    aws = ./cloud/aws;
    aws-aarch64 = ./cloud/aws/aarch64.nix;
    ci = ./ci.nix;
    cloud = ./cloud;
    denbeigh = ./denbeigh.nix;
    development = ./development.nix;
    gaming = ./gaming.nix;
    nix-cache = ./nix-cache.nix;
    router = ./router;
    standard = ./standard.nix;
    tailscale = ./tailscale.nix;
    terraform = ./terraform.nix;
    update-fonts = ./update-fonts;
    www = ./nginx;
  };
in
mapAttrs (_: path: import path) paths
