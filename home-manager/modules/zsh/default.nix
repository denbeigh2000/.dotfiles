{ pkgs, ... }:

let
  inherit (pkgs.stdenv) hostPlatform;

  linuxAliases = {
    clip = "xclip -selection CLIPBOARD $@";
  };

  shellAliases = {
    vim = "nvim";
  } // (if hostPlatform.isLinux then linuxAliases else { });

in
{
  programs = {
    fzf.enableZshIntegration = true;
    keychain.enableZshIntegration = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "gitfast" ];
        theme = "steeef";
      };

      inherit shellAliases;

      sessionVariables = {
        EDITOR = "nvim";
      };

      initExtra = (builtins.readFile ./zshrc);
    };
  };
}
