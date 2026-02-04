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
    ssh.enable = true;
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

  programs.ghostty = {
    enable = true;
    # Optional: enable shell integration
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    
    settings = {
      theme = "catppuccin-mocha";
      font-size = 14;
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

  # auto mount usb drives
  services.udiskie.enable = true;
}
