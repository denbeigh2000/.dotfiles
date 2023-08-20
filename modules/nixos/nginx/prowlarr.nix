import ./service.nix {
  name = "prowlarr";
  backend = "http://localhost:9696";
  tailscale = true;
}
