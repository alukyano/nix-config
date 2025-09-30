{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
    # GUI dev tools
        jetbrains.pycharm-community
        vscode
        vscode-extensions.golang.go
        vscode-extensions.ms-python.python
    #desktop stuff   
        qgis
        telegram-desktop
        appimage-run
        qdirstat
        sqlitebrowser
        nedit # Text editor for LARGE text files.
        freetube
        obsidian
        libreoffice
        #notepad-next
    # Media stuff:
        vlc
        handbrake
        krita # Photoshop alternative... Ish...
        digikam # Also installs showfoto
        shotwell
        simplescreenrecorder
        xnviewmp
        loupe
        inkscape-with-extensions
        gimp-with-plugins
        evince
        viewnior
    # VPN
        nekoray 
    # Cloud    
        yandex-disk 
    # Browsers
        firefox
        chromium  
    ];

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