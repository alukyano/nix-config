{ lib, config, pkgs, username, ... }:

{

  nix.settings = {
    download-buffer-size = 524288000; # 500 MiB
  };

  imports = [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include modules    
      ../../modules/common.nix
      ../../modules/syncthing.nix
      ../../modules/nvidia-buldozer.nix
      ../../modules/cinnamon-desktop.nix
      #../../modules/xfce-desktop.nix
      ../../modules/desktop.nix
      ../../modules/fonts.nix
      ../../modules/netbird.nix
      ../../modules/rustdesk-unstable.nix
      ../../modules/remote.nix
      ../../modules/virtualisation.nix
      ../../modules/docker.nix
      ../../modules/ai_cuda.nix  
      ../../modules/xrdp.nix
      ../../modules/civ.nix  
      #../../modules/gitlab.nix  
      #../../modules/n8n.nix
      #../../modules/adb.nix
      #../../modules/wine.nix
      #../../modules/games.nix
      #../../modules/winboat.nix
      #../../modules/proxy.nix
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
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
  ];
  
    # Swappiness to reduce swapfile usage.
  boot.kernel.sysctl = { "vm.swappiness" = 10;};
  boot.kernelParams = [ "ipv6.disable=1" ];
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
  #enp4s0f1 a8:1e:84:7e:ec:9f
  # networking.interfaces.enp4s0f1.useDHCP = true;
  # networking.interfaces.br0.useDHCP = true;
  # networking.interfaces.br0.macAddress = "a8:1e:84:7e:ec:9f";
  # networking.bridges = {
  #   "br0" = {
  #     interfaces = [ "enp4s0f1" ];
  #   };
  # };
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

  #services.xserver.displayManager.defaultSession = "xfce";
  services.displayManager.defaultSession = lib.mkForce "cinnamon";

}
