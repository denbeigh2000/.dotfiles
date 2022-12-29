{
  imports = [
    # Ensure our options are defiles before anything else
    ./config.nix
    ./dhcp.nix
    ./dns
    ./dyndns.nix
    ./firewall.nix
  ];
}
