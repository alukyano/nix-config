
{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../include/rustdesk.nix
      ../include/fonts.nix
      ../include/nvidia.nix
      ../include/virtualisation.nix
      ../include/packages-common.nix
      ../include/packages-desktop.nix
      ../include/packages-gnome.nix
      ../include/games.nix
      ../include/ai.nix
      ../include/netbird.nix
    ];

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
 
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Swappiness to reduce swapfile usage.
  boot.kernel.sysctl = { "vm.swappiness" = 10;};
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.useTmpfs = true;

  boot.initrd.kernelModules = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  swapDevices = [{
    device = "/swapfile";
    size = 4 * 1024;
  }];

  hardware.graphics = {
    enable = true;
  };

  networking.hostName = "msc-xalukyano"; # Define your hostname.
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alukyano = {
    isNormalUser = true;
    description = "Alex";   
    hashedPassword = "$6$V8olEhX1KSVilxP/$PZwWTNcDA7Zw.fARC6hGVGYsOgzkwtFf3tt1Zwi2yFuHa.Ib7jiByZaDEZIEe05c9Z.RNZDiliAVX0XQxgKDP0";
    extraGroups = [ "networkmanager" "wheel" "render" "video" "libvirt" "docker" ];
    packages = with pkgs; [
    #  
    ];
  };
  
  environment = {
    enableDebugInfo = true;
    localBinInPath = true;
    sessionVariables = {
    #CUDA_PATH = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
    LD_LIBRARY_PATH = [
      "/usr/lib/wsl/lib"
      "${pkgs.linuxPackages.nvidia_x11}/lib"
      "${pkgs.ncurses5}/lib"
      "/run/opengl-driver/lib"
    ];
    MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
  environment.systemPackages =  [
   # python fix
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec ${pkgs.python3}/bin/python "$@"
    '')
   # Remote Connect Applications
     pkgs.realvnc-vnc-viewer
     pkgs.remmina  
     pkgs.wine
     pkgs.winetricks
     pkgs.google-chrome
     pkgs.onlyoffice-bin
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options ="-delete-older-than 7d";
  };
}

