{pkgs, ...}: {
    
# Enable the X11 windowing system.
    services.libinput.enable = true;
    services.xserver = {
        enable = true;
        displayManager = {
            lightdm.enable = true;
            defaultSession = "cinnamon"; 
        };
        desktopManager.cinnamon.enable = true;

        xkb.layout = "us,ru";
        xkb.options = "grp:ctrl_shift_toggle";
    };   
   
   environment.systemPackages = with pkgs; [
      # cinnamon
		cinnamon.cinnamon-common
		cinnamon.cinnamon-control-center
		cinnamon.cinnamon-settings-daemon
		cinnamon.cinnamon-session
		cinnamon.cinnamon-menus
		cinnamon.cinnamon-translations
		cinnamon.cinnamon-screensaver
		cinnamon.cinnamon-desktop
      # gnome
        gnome-terminal
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
