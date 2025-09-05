
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  system.stateVersion = "25.05";
  
  systemd.sleep.extraConfig = ''
  AllowSuspend=no
  AllowHibernation=no
  AllowHybridSleep=no
  AllowSuspendThenHibernate=no
'';
 
  systemd.services."rustdesk" = {
    enable = true;
    path = with pkgs; [
      pkgs.rustdesk
      procps
      # This doesn't work since the version of sudo that will then be in the
      # path, won't have the setuid bit set
      # sudo
      # See the trick in `script` below modifying the path
    ];
    description = "RustDesk";
    requires = [ "network.target" ];
    after= [ "systemd-user-sessions.service" ];
    script = ''
      export PATH=/run/wrappers/bin:$PATH
      ${pkgs.rustdesk}/bin/rustdesk --service
    '';
    serviceConfig = {
      ExecStop = "${pkgs.procps}/pkill -f 'rustdesk --'";
      PIDFile = "/run/rustdesk.pid";
      KillMode = "mixed";
      TimeoutStopSec = "30";
      User = "root";
      LimitNOFILE = "100000";
    };
    wantedBy = [ "multi-user.target" ];
  };
  
  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = false;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  
  hardware.graphics = {
    enable = true;
  };
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Swappiness to reduce swapfile usage.
  boot.kernel.sysctl = { "vm.swappiness" = 10;};
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.useTmpfs = true;

  boot.initrd.kernelModules = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];
  
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
  
  networking.hostName = "msc-xalukyano"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
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
    services.xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
        gdm.wayland = false;
      };
      desktopManager.gnome.enable = true;

      xkb.layout = "us,ru";
      #xkb.variant = "workman,";
      xkb.options = "grp:ctrl_shift_toggle";
    };


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
  };

  
  services.ollama = { 
    enable = true; 
#    acceleration="cuda"; 
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

  # Allow unfree packages
  nixpkgs.config = {
        allowUnfree = true;
#        cudaSupport = true;
      };

  #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "cuda_cccl" "cuda_cudart" "cuda_nvcc" "libcublas" "nvidia-settings" "nvidia-x11" ]; 
  
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
    firefox.enable = true;
    gnome-terminal.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = 
  let
    nvidiaEnabled = lib.elem "nvidia" config.services.xserver.videoDrivers;
  in
  (with pkgs; [
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in 
   pkgs.buildFHSEnv (base // {
     name = "fhs";
     targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config]; 
     profile = "export FHS=1"; 
     runScript = "fish"; 
     extraOutputsToInstall = ["dev"];
   }))
   #python fix
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec ${pkgs.python3}/bin/python "$@"
    '')
   # default
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
  
   # Browsers
     chromium
     brave
     librewolf
     google-chrome
     
     # Langs
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
     wine
     winetricks
     uv
     #python310.withPackages

   # Archives
     unrar
     unzip
     atool
     zip
     p7zip     
  
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
     onlyoffice-bin
     obsidian
     libreoffice
     gedit
   # Media stuff:
     vlc
     handbrake
     krita # Photoshop alternative... Ish...
     digikam # Also installs showfoto
     shotwell
     simplescreenrecorder
     xnviewmp
     loupe
   # Remote Connect Applications
     rustdesk
     realvnc-vnc-viewer
     remmina     
   # media
     ffmpeg
     yt-dlp
     notepad-next
     dive
     podman-tui
     podman-compose 
   # AI
     openai-whisper 
   # gnome
     gnome-terminal
     gnome-system-monitor
     nautilus   
     gnome-tweaks
     gnomeExtensions.user-themes     
     gnomeExtensions.signal-shell 
     gnomeExtensions.appindicator
     gnomeExtensions.blur-my-shell
     gnomeExtensions.coverflow-alt-tab
     gnomeExtensions.desktop-cube
     gnomeExtensions.dock-from-dash
     gnomeExtensions.just-perfection
     gnomeExtensions.rounded-window-corners-reborn
     gnomeExtensions.rounded-corners
     gnomeExtensions.gpu-profile-selector
  ])
  ++ lib.optionals nvidiaEnabled [
    (config.hardware.nvidia.package.settings.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.vulkan-headers ];
    }))
  ];
  
    fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      hack-font
      fira-code
      fira-code-symbols
      ubuntu_font_family
      inconsolata
      noto-fonts
      noto-fonts-emoji
      jetbrains-mono
      julia-mono
      meslo-lg
      meslo-lgs-nf
      google-fonts
    ];
  };
  
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd = {
 #     enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
  
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
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

