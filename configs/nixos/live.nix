{
  config = {
    system = "x86_64-linux";
    modules = [
      {
        services.openssh.enable = true;
        networking.firewall.allowedTCPPorts = [ 22 ];
      }
      ({ self, modulesPath, ... }: {
        imports = [
          self.nixosModules.cloud
          self.nixosModules.standard
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
