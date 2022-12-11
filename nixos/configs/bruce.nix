let
  mod = location: ../modules/${location};
in
{
  # Specific to this configuration system
  host = {
    system = "x86_64-linux";
    work = false;
    hostname = "bruce";
    username = "denbeigh";
    graphical = false;
  };
  # General config to pass to nixosSystem
  # NOTE: Hardware is auto-detected by matching filenames in ./hardware
  config = {
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
    ];
  };
}
