{ config, lib, pkgs, ... }:
{
fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      hack-font
      fira-code
      fira-code-symbols
      ubuntu_font_family
      inconsolata
      noto-fonts
      noto-fonts-emoji
      jetbrains-mono
      julia-mono
      meslo-lg
      meslo-lgs-nf
      google-fonts
    ];
  };
}