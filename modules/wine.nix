{pkgs, ...}: {
environment.systemPackages = with pkgs; [
    wineWowPackages.wayland
    wine
    winetricks
  ];
}