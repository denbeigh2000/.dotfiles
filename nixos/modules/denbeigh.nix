{ pkgs, ... }:

{
  users.users.denbeigh = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
