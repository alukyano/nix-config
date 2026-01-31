{lib, config, pkgs, ...}: {
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "gnome-session"; 
  #services.xrdp.defaultSession = "xorg";
    # # Optional: tweak xrdp / Xorg configuration if you need
    # # (most setups work out‑of‑the‑box).
  extraConfig = ''
    [Xorg]
    pam_auth = /etc/X11/Xwrapper.config
  '';
}