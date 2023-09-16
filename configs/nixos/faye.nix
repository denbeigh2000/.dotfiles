{
  config = {
    modules = [
      ({ self, ... }:
        {
          imports = [
            ../../modules/nixos/standard.nix
            ../../modules/nixos/router
          ];
          config = {
            nixpkgs.hostPlatform = "x86_64-linux";
            system.stateVersion = "22.05";

            boot = {
              loader.grub = {
                enable = true;
                version = 2;
                device = "/dev/sda";
              };
              kernelParams = [
                "console=ttyS0,115200"
                "console=tty1"
              ];
            };

            services.openssh = {
              enable = true;
              openFirewall = false;
            };

            denbeigh = {
              services = {
                router = {
                  enable = true;
                  interfaces = {
                    lan = "eno4";
                    wan = "eno2";
                  };
                  ddns.enable = true;
                };
              };

              machine = {
                hostname = "faye";
                location = self.lib.locations.sf;
              };
            };

            # TODO: Use a more DRY setup for this
            age.identityPaths = [ "/var/lib/denbeigh/host_key" ];
          };
        })
    ];
  };
}
