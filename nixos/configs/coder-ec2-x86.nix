{
  system = "x86_64-linux";
  config = {
    modules = [
      ../modules/standard.nix
      ../modules/cloud/aws
      ../modules/cloud
      {
        denbeigh.machine.hostname = "dev";
      }
    ];
  };
}
