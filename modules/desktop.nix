{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
    # GUI dev tools
       #jetbrains.pycharm-community
        vscode
        vscode-extensions.golang.go
        vscode-extensions.ms-python.python
        far2l
    #desktop stuff   
        qgis
        telegram-desktop
        appimage-run
        qdirstat
        sqlitebrowser
        #nedit # Text editor for LARGE text files.
        freetube
        obsidian
        libreoffice
        libsecret
        #notepad-next
    # Media stuff:
        vlc
        #handbrake
        krita # Photoshop alternative... Ish...
        digikam # Also installs showfoto
        shotwell
        simplescreenrecorder
        xnviewmp
        loupe
        feh
        inkscape-with-extensions
        gimp-with-plugins
        evince
        viewnior
    # VPN
        throne # former nekoray 
    # Cloud    
        yandex-disk 
    # Browsers
        firefox
        chromium
    #terminals
        alacritty  
        alacritty-theme
        kitty
        kitty-themes
        ghostty
    ];


  programs.throne.tunMode.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.geoclue2.enable = true;
  
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd glib libGL
    ];
  };    
}