{ self, pkgs, ... }:

{
  imports = [ ./docker.nix ];

  nixpkgs.overlays = [ self.inputs.agenix.overlays.default ];

  environment.systemPackages = with pkgs; [
    agenix
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
