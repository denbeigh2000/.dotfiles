{ cloud
, www
, ahoy
, ci
, nix-cache
, standard
, tailscale
, terraform
, ...
}:

let
  mod = location: ../../modules/nixos/${location};
in
{
  # NOTE: Hardware is auto-detected by matching filenames in ./hardware
  config = {
    system = "x86_64-linux";
    modules = [
      {
        services.openssh.enable = true;
        networking.firewall.allowedTCPPorts = [ 22 ];
      }
      cloud
      www
      ahoy
      ci
      nix-cache
      standard
      tailscale
      terraform
      {
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
        };

        # TODO: Use a more DRY setup for this
        age.identityPaths = [ "/var/lib/denbeigh/host_key" ];
      }
    ];
  };
}
