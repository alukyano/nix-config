{ config, lib, pkgs, ... }:
{
  services.netbird.enable = true;  # Enables the NetBird service and CLI
    environment.systemPackages = with pkgs; [
        netbird-ui
    ];
}