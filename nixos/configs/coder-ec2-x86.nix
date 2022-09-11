[
  ../modules/denbeigh.nix
  ../modules/cloud
  ../modules/cloud/aws

  {
    networking = {
      hostName = "dev";
      domain = "denbeigh.cloud";
    };

    hmConfig = "coder";
  }
]
