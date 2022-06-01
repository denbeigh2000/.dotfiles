{ config, pkgs, ... }:

let
  hostname = (pkgs.lib.removeSuffix "\n" (builtins.readFile "/etc/hostname"));

  hosts = {
    martha = {
      work = false;
      graphical = "single";
      username = "denbeigh";
      home = "/home/denbeigh";
      keys = ["id_ed25519"];
    };
    mutant = {
      work = true;
      graphical = "single";
      username = "denbeigh.stevens";
      home = "/Users/denbeigh.stevens";
      keys = ["id_ed25519"];
    };
  };

  configData = {
    common = {
      name = "Denbeigh Stevens";
    };

    personal = {
      email = "denbeigh@denbeighstevens.com";
    };

    work = {
      email = "denbeigh.stevens@discordapp.com";
    };
  };

  host = hosts."${hostname}";
  variant = if host.work then "work" else "personal";
  config = configData.common // configData."${variant}";

  linuxAliases = {
    clip = "xclip -selection CLIPBOARD $@";
  };

  graphicalFiles = {
    i3conf = {
      target = ".config/i3/config";
      text = (import ./i3/default.nix { configuration = host.graphical; });
    };
  };
in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = host.username;
    home.homeDirectory = host.home;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.05";

    home.file.i3conf = graphicalFiles.i3conf;

    targets.genericLinux.enable = true;

    home.packages = with pkgs; [
      glibcLocales
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.alacritty = {
      enable = true;
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
            black =   "0x282828";
            red =     "0xcc241d";
            green =   "0x98971a";
            yellow =  "0xd79921";
            blue =    "0x458588";
            magenta = "0xb16286";
            cyan =    "0x689d6a";
            white =   "0xa89984";
          };

          # Bright colors
          bright = {
            black =   "0x928374";
            red =     "0xfb4934";
            green =   "0xb8bb26";
            yellow =  "0xfabd2f";
            blue =    "0x83a598";
            magenta = "0xd3869b";
            cyan =    "0x8ec07c";
            white =   "0xebdbb2";
          };
        };

        font = {
          normal = {
            family = "Roboto Mono for Powerline";
            style = "Regular";
          };
          bold = {
            family = "Roboto Mono for Powerline";
            style = "Bold";
          };
          italic = {
            family = "Roboto Mono for Powerline";
            style = "Italic";
          };
          size = 10;
        };

        visual_bell = {
          animation = "EaseOutExpo";
          duration = 25;
          color = "0x504945";
        };
      };
    };

    programs.aria2.enable = true;
    programs.jq.enable = true;

    programs.keychain = {
      enable = true;
      inherit (host) keys;
      enableZshIntegration = true;
    };

    programs.git = {
      enable = true;
      userName = config.name;
      userEmail = config.email;
      extraConfig = {
        help.autocorrect = -1;
        merge.ff = "only";
        fetch.prune = true;
      };
    };

    programs.gh.enable = true;

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;

      oh-my-zsh = {
        enable = true;
        plugins = ["git" "rust"];
        theme = "steeef";
      };

      shellAliases = {
        vim = "nvim";
      } // linuxAliases;

      sessionVariables = {
        EDITOR = "nvim";
      };

      initExtra = (builtins.readFile ./zsh/zshrc);
    };
  }

