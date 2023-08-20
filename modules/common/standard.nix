{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh = {
    enable = true;
    promptInit = "";
  };

  environment.systemPackages = with pkgs; [
    git
    nix
  ];
}
