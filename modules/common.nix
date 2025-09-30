{
  pkgs,
  lib,
  username,
  ...
}: {
  # ============================= User related =============================

  #builders-use-substitutes = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Alex";   
    hashedPassword = "$6$V8olEhX1KSVilxP/$PZwWTNcDA7Zw.fARC6hGVGYsOgzkwtFf3tt1Zwi2yFuHa.Ib7jiByZaDEZIEe05c9Z.RNZDiliAVX0XQxgKDP0";
    extraGroups = [ "networkmanager" "wheel" "render" "video" "qemu-libvirtd" "libvirtd" "docker" ];
    packages = with pkgs; [
    #  
    ];
  };

  nix.settings.trusted-users = [username];
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

  programs.dconf.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = true; # disable password login
    };
    openFirewall = true;
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
        sysstat
        lm_sensors # for `sensors` command        
        rsync
        neofetch
        git
        gdal
        gperftools
        neovim
        imagemagick
        nnn
        dysk
        duf
    # Dev
        libsecret
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
}
