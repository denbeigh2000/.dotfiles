import ./service.nix {
  name = "sonarr";
  backend = "http://localhost:8989";
  tailscale = true;
}
