{ config, lib, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
      # gnome
        gnome-terminal
        gnome-system-monitor
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
}