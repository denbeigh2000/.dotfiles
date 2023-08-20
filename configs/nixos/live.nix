{ cloud, standard }:

{
  config = {
    system = "x86_64-linux";
    modules = [
      {
        services.openssh.enable = true;
        networking.firewall.allowedTCPPorts = [ 22 ];
      }
      cloud
      standard
      ({ modulesPath, ... }: {
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      })
      {
        denbeigh.machine.hostname = "live";
        denbeigh.user.enable = false;
      }
    ];
  };
}
