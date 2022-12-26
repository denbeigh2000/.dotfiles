let
  mod = location: ../modules/${location};
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
      (mod "cloud")
      (mod "nginx")
      (mod "ahoy.nix")
      (mod "ci.nix")
      (mod "secrets.nix")
      (mod "standard.nix")
      (mod "tailscale.nix")
      (mod "terraform.nix")
      {
        denbeigh = {
          machine = {
            hostname = "bruce";
            domain = "denbeigh.cloud";
          };
        };
      }
    ];
  };
}
