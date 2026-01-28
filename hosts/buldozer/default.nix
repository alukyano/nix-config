# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  nix.settings = {
    download-buffer-size = 524288000; # 500 MiB
  };

  imports = [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include modules    
      ../../modules/common.nix
      ../../modules/nvidia-prime-intel.nix
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
      ../../modules/adb.nix
      ../../modules/wine.nix
      ../../modules/ai.nix  
      ../../modules/winboat.nix
      ../../modules/ai_agents.nix  
      ];
  
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

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
  
    # Swappiness to reduce swapfile usage.
  boot.kernel.sysctl = { "vm.swappiness" = 10;};

  boot.tmp.useTmpfs = true;

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];
  
    systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
    '';

  networking.hostName = "buldozer"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.";

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd glib libGL
    ];
  };

  #environment.systemPackages = with pkgs; [
  #];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options ="-delete-older-than 7d";
  };

}
