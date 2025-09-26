{pkgs, ...}: {
   environment.systemPackages = with pkgs; [
      # gnome
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