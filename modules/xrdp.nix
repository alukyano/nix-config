{pkgs, ...}: {
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xfce-session"; 
}