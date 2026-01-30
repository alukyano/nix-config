{pkgs, ...}: {
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "cinnamon-session"; 
}