{ self
, lib
, pkgs
, home-manager
, hostname
, ...
}:

with lib;
let
  # inherit (config) hmConfig;
  hmConfig = "coder";
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  config = {
    hmConfig = mkOption {
      type = types.str;
      default = null;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.denbeigh =  self.homeConfigurations.${hmConfig};
  };

  users.users.denbeigh = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
