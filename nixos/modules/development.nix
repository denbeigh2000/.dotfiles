{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    kubectl
    neovim
    nix
  ];

  # Required for libvirtd
  security.polkit.enable = true;
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
}
