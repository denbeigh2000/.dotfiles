{ pkgs, ... }:

let
  inherit (pkgs.stdenv) hostPlatform;

  linuxAliases = {
    clip = "xclip -selection CLIPBOARD $@";
  };

  shellAliases = {
    vim = "nvim";
    fuck =
      let
        sedBin = "${pkgs.gnused}/bin/sed";
        sedCmd = "s/^\\(.*\\)/sudo \\1/g";
      in
      "fc -e \"${sedBin} -i '${sedCmd}'\"";
  } // (if hostPlatform.isLinux then linuxAliases else { });

in
{
  programs = {
    fzf.enableZshIntegration = true;
    keychain.enableZshIntegration = true;

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

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
