
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../include/fonts.nix
      ../include/packages-common.nix
      ../include/packages-desktop.nix
      ../include/packages-gnome.nix
      ../include/bash.nix
      ../include/xfce.nix
    ];

  system.stateVersion = "25.05";
  
  virtualisation.vmware.guest.enable = true;
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Swappiness to reduce swapfile usage.
  boot.kernel.sysctl = { "vm.swappiness" = 10;};
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.useTmpfs = true;

  swapDevices = [{
    device = "/swapfile";
    size = 4 * 1024;
  }];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nixpkgs-wayland.cachix.org"
  ];
  
  networking.hostName = "nixer"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.libinput.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
  #services.cinnamon.apps.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alukyano = {
    isNormalUser = true;
    description = "Alex";
    extraGroups = [ "networkmanager" "wheel" "render" "video" "libvirt" ];
    packages = with pkgs; [
    #  
    ];
  };
  
  environment = {
    enableDebugInfo = true;
    localBinInPath = true;
    sessionVariables = {
      SSH_ASKPASS_REQUIRE="prefer";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd glib libGL
    ];
  };
  
  programs = {
    fish.enable = true;
    java.enable = true;
    dconf.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in 
   pkgs.buildFHSEnv (base // {
     name = "fhs";
     targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config]; 
     profile = "export FHS=1"; 
     runScript = "fish"; 
     extraOutputsToInstall = ["dev"];
   }))
     remmina
  ];
  
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a 'docker' alias for podman, to use it as a drop in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options ="-delete-older-than 7d";
  };
}

