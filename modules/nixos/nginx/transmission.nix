import ./service.nix {
  name = "transmission";
  backend = "http://localhost:9091";
  tailscale = true;
}
