{
  # NOTE: Hardware is auto-detected by matching filenames in ./hardware
  config = {
    system = "x86_64-linux";
    modules = [
      {
        services.openssh.enable = true;
        networking.firewall.allowedTCPPorts = [ 22 ];
      }
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
          ];
          config = {
            denbeigh = {
              machine = {
                hostname = "bruce";
                domain = "denbeigh.cloud";
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
