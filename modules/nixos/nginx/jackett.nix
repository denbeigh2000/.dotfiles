import ./service.nix {
  name = "jackett";
  backend = "http://localhost:9117";
  tailscale = true;
}
