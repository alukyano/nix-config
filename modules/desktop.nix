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
    ];
}