{
  config = {
    modules = [
      ../modules/standard.nix
      ../modules/cloud/aws
      ../modules/cloud
      {
        denbeigh.machine.hostname = "dev";
        nixpkgs.hostPlatform = "x86_64-linux";
      }
    ];
  };
}
