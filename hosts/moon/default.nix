
{ config, lib, pkgs, username, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include modules    
      ../../modules/common.nix
      ../../modules/syncthing.nix
      ../../modules/intel.nix
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
      #../../modules/n8n.nix
      #../../modules/adb.nix
      ../../modules/wine.nix
      ../../modules/ai_cpu.nix
      ../../modules/xrdp.nix
      ../../modules/winboat.nix
      ../../modules/ai_agents.nix 
    ];

  system.stateVersion = "25.11";
  
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
 
  # Bootloader.  
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swappiness to reduce swapfile usage.
  boot.kernel.sysctl = { "vm.swappiness" = 10;};
  boot.kernelParams = [ "ipv6.disable=1" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.useTmpfs = true;

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
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

  networking.hostName = "moon"; # Define your hostname.
  networking.networkmanager.enable = true;
  # enp44s0 58:47:ca:7c:db:e9
  networking.interfaces.enp44s0.useDHCP = true;
  networking.interfaces.br0.useDHCP = true;
  networking.interfaces.br0.macAddress = "58:47:ca:7c:db:e9";
  networking.bridges = {
    "br0" = {
      interfaces = [ "enp44s0" ];
    };
  }; 
  # Allow unfree packages
  #nixpkgs.config.nvidia.acceptLicense = true;
  
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

