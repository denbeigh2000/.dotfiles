{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jq
    git
    htop
    vim
    neovim
    ripgrep
    ctags
    docker
    docker-compose
  ];
}
