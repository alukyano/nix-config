# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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

  networking.hostName = "acernb"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
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
  
    # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:ctrl_shift_toggle";
    variant = "";
  };

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xfce-session"; 
    
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;




  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    # Browsers
        chromium
        brave
        librewolf
        vivaldi
        vivaldi-ffmpeg-codecs
    # GUI dev tools
        jetbrains.pycharm-community
        vscode
        vscode-extensions.golang.go
        vscode-extensions.ms-python.python
    #desktop stuff   
        qgis
        telegram-desktop
        appimage-run
        qdirstat
        sqlitebrowser
        nedit # Text editor for LARGE text files.
        freetube
        obsidian
        libreoffice
        #notepad-next
    # Media stuff:
        vlc
        handbrake
        krita # Photoshop alternative... Ish...
        digikam # Also installs showfoto
        shotwell
        simplescreenrecorder
        xnviewmp
        loupe
        inkscape-with-extensions
        gimp-with-plugins
        evince        
  ];


  nix.gc = {
    automatic = true;
    dates = "weekly";
    options ="-delete-older-than 7d";
  };

}
