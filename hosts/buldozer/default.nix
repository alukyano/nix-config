# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ../../modules/xfce-desktop.nix
    ../../modules/desktop.nix
    ../../modules/games.nix
    ../../modules/fonts.nix
    ../../modules/netbird.nix
    ../../modules/nvidia-compute.nix
    ../../modules/rustdesk.nix
    ../../modules/remote.nix
    ../../modules/virtualisation.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

  
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  system.stateVersion = "25.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nixpkgs-wayland.cachix.org"
    "https://cuda-maintainers.cachix.org"
  ];
  
    # Swappiness to reduce swapfile usage.
  boot.kernel.sysctl = { "vm.swappiness" = 10;};
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.useTmpfs = true;

  swapDevices = [{
    device = "/swapfile";
    size = 4 * 1024;
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
    
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd glib libGL
    ];
  };

  environment.systemPackages = with pkgs; [
        nix-index
        cachix
        binutils
        direnv
        exfat
        nox
        ntfs3g
        patchelf
        pciutils
        wget
        curl
        jq
        mc
        htop
        rsync
        neofetch
        git
        gdal
        gperftools
        neovim
        imagemagick
    # Dev
        go
        llvmPackages_latest.bintools
        llvmPackages_latest.clang
        llvmPackages_latest.lldb
        llvmPackages_latest.stdenv
        maven
        nil
        ninja
        nodejs
        protobuf
        gcc
        libgcc
        clang-tools
        cmake
        jre_minimal
        jdk
        uv
        zsh
    # Archives
        unrar
        unzip
        atool
        zip
        p7zip  
    # media
        ffmpeg
        yt-dlp    
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options ="-delete-older-than 7d";
  };

}
