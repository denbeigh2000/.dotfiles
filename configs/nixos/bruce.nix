{
  # NOTE: Hardware is auto-detected by matching filenames in ./hardware
  config = {
    modules = [
      ({ self, config, ... }:
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

            self.inputs.gridder.nixosModules.default
            { nixpkgs.overlays = [ self.inputs.gridder.overlays.default ]; }
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

            gridder = {
              enable = true;
              spreadsheetID = "14ArkUcM0k4nhNE_Ng-p0Ahb06yh_CBr4SgjiBrj6FFA";
              serviceAccountPath = config.age.secrets.gridderServiceAccount.path;
              # these are default, but set them explicitly so that the
              # ownership of the secret below is always correct.
              username = "gridder";
              group = "gridder";
            };

            age.secrets.gridderServiceAccount = {
              file = ../../secrets/gridderServiceAccount.age;
              owner = "gridder";
              group = "gridder";
            };

            # TODO: Use a more DRY setup for this
            age.identityPaths = [ "/var/lib/denbeigh/host_key" ];
          };
        })
    ];
  };
}
