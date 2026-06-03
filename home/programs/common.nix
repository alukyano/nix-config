{
  lib,
  pkgs,
  catppuccin-bat,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip
    unrar

    # utils
    ripgrep
    yq-go # https://github.com/mikefarah/yq
    htop

    # misc
    libnotify
    xdg-utils
    graphviz

    # productivity
    obsidian

    # IDE
    insomnia

    # cloud native
    docker-compose
    kubectl

    # db related
    dbeaver-bin
    mycli
    pgcli
  ];

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        #theme = "catppuccin-mocha";
      };
      # themes = {
      #   # https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme
      #   catppuccin-mocha = {
      #     src = catppuccin-bat;
      #     file = "Catppuccin-mocha.tmTheme";
      #   };
      # };
    };

    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    jq.enable = true; # A lightweight and flexible command-line JSON processor
    #ssh.enable = true;
    aria2.enable = true;

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };
  };

    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 15;
      };
      shellIntegration.enableFishIntegration = true;
      themeFile = "Catppuccin-Macchiato";
      #Also available: Catppuccin-Frappe Catppuccin-Latte Catppuccin-Macchiato Catppuccin-Mocha
      # See all available kitty themes at: https://github.com/kovidgoyal/kitty-themes/blob/46d9dfe230f315a6a0c62f4687f6b3da20fd05e4/themes.json
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          size = 15.0; # Adjust to your preference
          
          normal = {
            family = "FiraCode Nerd Font"; # Exact name of the font
            style = "Regular";
          };
          
          bold = {
            family = "FiraCode Nerd Font";
            style = "Bold";
          };
          
          italic = {
            family = "FiraCode Nerd Font";
            style = "Italic";
          };
        };
      };
    };

    programs.ghostty = {
      enable = true;
      # Optional: enable shell integration
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      
      settings = {
          theme = "Cursor Dark";
          font-size = 15;
          font-family = "JetBrainsMono Nerd Font";
          background-opacity = 0.9;
          #window-decoration = false; # Example: remove title bar
          window-padding-x = 10;
          window-padding-y = 10;
          keybind = [
            "ctrl+shift+n=new_window"
            "ctrl+shift+w=close_surface"
          ];
        };
    };

  programs.bash.enable = true;
  
  # auto mount usb drives
  services.udiskie.enable = true;
}
