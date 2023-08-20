import ./service.nix {
  name = "radarr";
  backend = "http://localhost:7878";
  tailscale = true;
}
