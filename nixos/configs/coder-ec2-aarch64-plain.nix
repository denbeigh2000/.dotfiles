{
  config = {
    system = "aarch64-linux";
    modules = [
      ../modules/standard.nix
      ../modules/cloud/aws/aarch64.nix
      ../modules/cloud
      {
        denbeigh.machine.hostname = "plain";
      }
    ];
  };
}
