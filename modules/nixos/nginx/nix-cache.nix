import ./service.nix {
  name = "nix-cache";
  backend = "http://localhost:5000";
  tailscale = true;
}
