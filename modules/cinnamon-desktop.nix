{lib, pkgs, ...}: {
   
   # Enable the X11 windowing system.
    services.libinput.enable = true;
    
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us,ru";
    services.xserver.xkb.options = "grp:ctrl_shift_toggle";
    services.xserver.desktopManager.cinnamon.enable = true;

    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.displayManager.autoLogin.enable = false;
    services.xserver.displayManager.defaultSession = lib.mkDefault "cinnamon";
    #services.displayManager.gdm.wayland = false;
    #services.displayManager.lightdm.autoSuspend = false;  
    hardware.graphics.enable = true;

    environment.systemPackages = with pkgs; [
      # cinnamon
		cinnamon-common
		cinnamon-control-center
		cinnamon-settings-daemon
		cinnamon-session
		cinnamon-menus
		cinnamon-translations
		cinnamon-screensaver
		cinnamon-desktop
    # gnome
    gnome-terminal
    gnome-session
    gnome-system-monitor
    file-roller
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
