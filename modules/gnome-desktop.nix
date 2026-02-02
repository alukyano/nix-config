{pkgs, ...}: {
    
# Enable the X11 windowing system.
    services.libinput.enable = true;
    
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    #services.displayManager.gdm.wayland = false;
    services.displayManager.gdm.autoSuspend = false;
    services.displayManager.autoLogin.enable = false;
    services.desktopManager.gnome.enable = true;
    services.xserver.xkb.layout = "us,ru";
    services.xserver.xkb.options = "grp:ctrl_shift_toggle";

    services.gnome.gnome-remote-desktop.enable = true;
    services.xrdp.enable = true;
    services.xrdp.openFirewall = true;
    services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
   
    hardware.graphics.enable = true;

    environment.systemPackages = with pkgs; [
      # gnome
        gnome-session
        gnome-terminal
        gnome-system-monitor
        file-roller
        gnome-disk-utility
        nautilus  
        gedit 
        gnome-tweaks
        gnomeExtensions.user-themes     
        gnomeExtensions.signal-shell 
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell
        gnomeExtensions.coverflow-alt-tab
        gnomeExtensions.desktop-cube
        gnomeExtensions.dock-from-dash
        gnomeExtensions.just-perfection
        gnomeExtensions.rounded-window-corners-reborn
        gnomeExtensions.rounded-corners
        gnomeExtensions.gpu-profile-selector
   ];

    programs = {
        gnome-terminal.enable = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
}
