{
  # Specific to this configuration system
  host = {
    system = "x86_64-linux";
    work = false;
    hostname = "dev";
    username = "denbeigh";
    graphical = false;
  };
  # General config to pass to nixosSystem
  config = {
    modules = [
      ../modules/standard.nix
    ];
  };
}
