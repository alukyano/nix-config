{pkgs, ...}: {
environment.systemPackages = with pkgs; [
    wineWow64Packages.wayland
    wine
    winetricks
  ];
}