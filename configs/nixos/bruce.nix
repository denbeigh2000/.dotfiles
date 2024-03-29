{
  # NOTE: Hardware is auto-detected by matching filenames in ./hardware
  config = {
    modules = [
      ({ self, ... }:
        {
          imports = [
            # NOTE: Deduping imports from flake modules is broken(?)
            # https://github.com/NixOS/nix/issues/7270
            # Can't easily re-use from self.nixosModules (either here
            # or within) until resolved
            ../../modules/nixos/cloud
            ../../modules/nixos/nginx
            ../../modules/nixos/ahoy.nix
            ../../modules/nixos/ci.nix
            ../../modules/nixos/nix-cache.nix
            ../../modules/nixos/standard.nix
            ../../modules/nixos/tailscale.nix
            ../../modules/nixos/terraform.nix
            ../../modules/nixos/update-fonts.nix
          ];
          config = {
            nixpkgs.hostPlatform = "x86_64-linux";
            system.stateVersion = "22.05";

            denbeigh = {
              machine = {
                hostname = "bruce";
                domain = "denbeigh.cloud";
              };

              ssh = {
                enable = true;
                sshPort = 4742;
              };

              services = {
                www.enable = true;
                nix-cache = {
                  enable = true;
                  keyFile = "/var/lib/denbeigh/nix-cache/serve-key";
                };
              };

              ahoy.enable = true;
              tailscale.enable = true;
            };

            # TODO: Use a more DRY setup for this
            age.identityPaths = [ "/var/lib/denbeigh/host_key" ];
          };
        })
    ];
  };
}
