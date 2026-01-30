{lib, pkgs, ...}: {

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.displayManager.defaultSession = lib.mkDefault "xfce";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:ctrl_shift_toggle";
    variant = "";
  };

  environment = {
    systemPackages = with pkgs; [
      catfish
      gigolo
      orage
      xfburn
      xfce4-appfinder
      xfce4-clipman-plugin
      xfce4-cpugraph-plugin
      xfce4-dict
      xfce4-fsguard-plugin
      xfce4-genmon-plugin
      xfce4-netload-plugin
      xfce4-panel
      xfce4-pulseaudio-plugin
      xfce4-systemload-plugin
      xfce4-weather-plugin
      xfce4-whiskermenu-plugin
      xfce4-xkb-plugin
      xfdashboard
      xev
      xsel
      xtitle
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;


  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };
}