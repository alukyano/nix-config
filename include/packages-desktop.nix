{ config, lib, pkgs, ... }:
{
    
    systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
    '';
    
    programs = {
        firefox.enable = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    services.flatpak.enable = true;

    # Enable the X11 windowing system.
    services.libinput.enable = true;
    services.gnome.gnome-remote-desktop.enable = true;
    services.xserver = {
        enable = true;
        displayManager = {
            gdm.enable = true;
            gdm.wayland = false;
        };
        desktopManager.gnome.enable = true;

        xkb.layout = "us,ru";
        xkb.options = "grp:ctrl_shift_toggle";
    };
    
    environment.systemPackages = with pkgs; [
    # Browsers
        chromium
        brave
        librewolf
        vivaldi
        vivaldi-ffmpeg-codecs
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