{ config
, pkgs
, lib
, nixgl
, ...
}:

let
  inherit (lib) types mkOption;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  inherit (config.denbeigh) hostname isNixOS;

  # We only need to explicitly wrap if we're on linux and we are _not_ on NixOS
  inherit (config.denbeigh.alacritty) shouldGlWrap fontSize fontFamily;
  glWrap = import ../tools/gl.nix { inherit pkgs; };
  package = (
    if shouldGlWrap
    then (glWrap pkgs.alacritty "alacritty")
    else pkgs.alacritty
  );
in
{
  options.denbeigh.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install and manage Alacritty.
      '';
    };

    shouldGlWrap = mkOption {
      type = types.bool;
      # NOTE: Will this be OK?
      default = (isLinux && !isNixOS);
      description = ''
        Whether to wrap Alacritty in NixGL.
      '';
    };

    fontSize = mkOption {
      type = types.float;
      default = 10.0;
      description = ''
        Font size to use in terminal.
      '';
    };

    fontFamily = mkOption {
      type = types.str;
      default = "Roboto Mono for Powerline";
      description = ''
        Font to use in terminal.
      '';
    };
  };

  config = {
    nixpkgs.overlays = [ nixgl.overlay ];

    programs.alacritty = {
      enable = true;
      inherit package;
      settings = {
        # Colors (Gruvbox dark)
        colors = {
          primary = {
            # hard contrast = background = '0x1d2021'
            # background = '0x282828'
            # soft contrast = background = '0x32302f'
            background = "0x32302f";
            foreground = "0xebdbb2";
          };

          # Normal colors
          normal = {
            black = "0x282828";
            red = "0xcc241d";
            green = "0x98971a";
            yellow = "0xd79921";
            blue = "0x458588";
            magenta = "0xb16286";
            cyan = "0x689d6a";
            white = "0xa89984";
          };

          # Bright colors
          bright = {
            black = "0x928374";
            red = "0xfb4934";
            green = "0xb8bb26";
            yellow = "0xfabd2f";
            blue = "0x83a598";
            magenta = "0xd3869b";
            cyan = "0x8ec07c";
            white = "0xebdbb2";
          };
        };

        font = {
          normal = {
            family = fontFamily;
            style = "Regular";
          };
          bold = {
            family = fontFamily;
            style = "Bold";
          };
          italic = {
            family = fontFamily;
            style = "Italic";
          };
          size = fontSize;
        };

        visual_bell = {
          animation = "EaseOutExpo";
          duration = 25;
          color = "0x504945";
        };
      };
    };
  };
}
