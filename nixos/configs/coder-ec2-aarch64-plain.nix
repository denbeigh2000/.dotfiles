{
  config = {
    modules = [
      ../modules/standard.nix
      ../modules/cloud/aws/aarch64.nix
      ../modules/cloud
      {
        denbeigh.machine.hostname = "plain";
        nixpkgs.hostPlatform = "aarch64-linux";
      }
    ];
  };
}
