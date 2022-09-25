{ pkgs, agenix, ... }:

{
  imports = [ ./docker.nix ];

  nixpkgs.overlays = [ agenix.overlay ];

  environment.systemPackages = with pkgs; [
    # Force use of agenix from overlay, not function argument
    pkgs.agenix
    jq
    git
    htop
    vim
    neovim
    ripgrep
    ctags
    file
    unzip
  ];
}
