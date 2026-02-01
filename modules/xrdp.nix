{pkgs, ...}: {
  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;
  services.xrdp.defaultWindowManager = "cinnamon-session"; 
}