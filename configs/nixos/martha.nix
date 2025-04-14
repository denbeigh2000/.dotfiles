{
  config = {
    modules = [
      ({ self, ... }:
        {
          imports = [
            ../../modules/nixos/standard.nix
            ../../modules/nixos/tailscale.nix
            ../../modules/nixos/audio-streaming.nix
            ../../modules/nixos/wifi.nix
          ];
          config = {
            nixpkgs.hostPlatform = "x86_64-linux";
            system.stateVersion = "23.05";
            boot.loader.systemd-boot.enable = true;

            denbeigh = {
              machine = {
                hostname = "martha";
                graphical = false;
                location = self.lib.locations.sf;
              };
              audio-streaming = {
                enable = true;
                name = "kitchen";
              };
              ssh.enable = true;
              tailscale.enable = true;
              wifi = {
                enable = true;
                networks = [ "Sanctum" ];
                # primary network interface is non-functional, only use USB one
                interfaces = [ "wlp0s20f0u2" ];
              };
            };

            # TODO: Use a more DRY setup for this
            age.identityPaths = [ "/home/denbeigh/.ssh/id_ed25519" ];
          };
        })
    ];
  };
}

