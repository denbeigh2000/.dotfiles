{ standard, aws-aarch64, cloud, ... }:

{
  # General config to pass to nixosSystem
  config = {
    system = "aarch64-linux";
    modules = [
      standard
      aws-aarch64
      {
        denbeigh.machine.hostname = "dev";
      }
    ];
  };
}
