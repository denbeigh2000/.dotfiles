{
  host = {
    system = "x86_64-linux";
    work = false;
    hostname = "live";
    username = "denbeigh";
    graphical = false;
    location = "sf";
  };
  config = {
    modules = [
      {
        services.openssh.enable = true;
        networking.firewall.allowedTCPPorts = [ 22 ];
      }
      ../modules/cloud
      ../modules/standard.nix
      ({ modulesPath, ... }: {
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      })
    ];
  };
}
