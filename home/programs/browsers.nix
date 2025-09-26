{
  pkgs,
  config,
  username,
  ...
}: {
  programs = {
    chromium = {
      enable = true;
      #commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        # {id = "";}  // extension id, query from chrome web store
      ];
    };

    firefox = {
      enable = true;
      profiles.${username} = {};
    };
  };

  home.packages = with pkgs; [
        # Browsers
        chromium
        brave
        librewolf
        vivaldi
        vivaldi-ffmpeg-codecs
        google-chrome
  ];
  
  };
}
