{
  config = {
    system = "x86_64-linux";
    modules = [
      {
        services.openssh.enable = true;
        networking.firewall.allowedTCPPorts = [ 22 ];
      }
      ../../modules/nixos/cloud
      ../../modules/nixos/standard.nix
      ({ modulesPath, ... }: {
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      })
      {
        denbeigh.machine.hostname = "live";
      }
    ];
  };
}
