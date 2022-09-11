let 
  inherit (builtins) mapAttrs;

  paths = {
    cloud = ./cloud;
    aws = ./cloud/aws;
    aws-aarch64 = ./cloud/aws/aarch64.nix;
    denbeigh = ./denbeigh.nix;
    flakes = ./flakes.nix;
  };
in
  mapAttrs (_: path: import path) paths
