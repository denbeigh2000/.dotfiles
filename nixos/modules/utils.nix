{ pkgs, ... }:

{
  imports = [ ./docker.nix ];

  environment.systemPackages = with pkgs; [
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
