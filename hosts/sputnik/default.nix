
{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include modules    
      ../../modules/common.nix
      ../../modules/cinnamon-desktop.nix
      ../../modules/xfce-desktop.nix
      ../../modules/desktop.nix
      ../../modules/games.nix
      ../../modules/fonts.nix
      ../../modules/netbird.nix
      ../../modules/rustdesk.nix
      ../../modules/remote.nix
      ../../modules/virtualisation.nix
      ../../modules/docker.nix
      ../../modules/n8n.nix
      #../../modules/adb.nix
      ../../modules/wine.nix
      ../../modules/ai_na.nix
      ../../modules/xrdp.nix
      ../../modules/proxy.nix
      ../../modules/ai_agents.nix  
    ];

  system.stateVersion = "25.11";
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nixpkgs-wayland.cachix.org"
    "https://cuda-maintainers.cachix.org"
    "https://cache.numtide.com"
  ];
 
  # Bootloader.  
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swappiness to reduce swapfile usage.
  boot.kernel.sysctl = { "vm.swappiness" = 10;};
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.useTmpfs = true;

  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024;
  }];

  hardware.graphics = {
    enable = true;
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
    '';

  networking.hostName = "sputnik"; # Define your hostname.
  networking.networkmanager.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd glib libGL
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options ="-delete-older-than 7d";
  };

  #services.xserver.displayManager.defaultSession = "xfce";
  services.displayManager.defaultSession = lib.mkForce "cinnamon";
}
