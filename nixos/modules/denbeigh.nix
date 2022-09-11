{ lib
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
  options = {
    hmConfig = mkOption {
      type = types.str;
      default = null;
    };
  };

  config = {
    users.users.denbeigh = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        host = {
          work = false;
          hostname = "dev";
          system = "x86_64-linux";
          username = "denbeigh";
          graphical = "false";
          keys = null;
        };
      };

      users.denbeigh = {
        imports = [
          # Infinite recursion somewhere in these modules (or in keychain)
          # ../../modules/dev.nix
          ../../modules/git.nix
          # ../../modules/linux.nix
          # ../../modules/zsh
        ];

        # TODO: Don't copy-paste/pass these along
        home = {
          username = "denbeigh";
          homeDirectory = "/home/denbeigh";
          packages = with pkgs; [ ripgrep ];
        };

        programs = {
          # Let Home Manager install and manage itself.
          home-manager.enable = true;

          aria2.enable = true;
          jq.enable = true;

          # keychain = {
          #   enable = host.keys != null;
          #   inherit (host) keys;
          # };

          gh.enable = true;

          fzf.enable = true;
        };

        home.stateVersion = "22.05";
      };
    };
  };
}
