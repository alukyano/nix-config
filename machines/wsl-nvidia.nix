# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    ../include/virtualisation-wsl.nix
    ../include/nvidia-wsl.nix
    ../include/packages-common.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "alukyano";

  wsl.useWindowsDriver = true;
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

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alukyano = {
    isNormalUser = true;
    description = "Alex";
    hashedPassword = "$6$V8olEhX1KSVilxP/$PZwWTNcDA7Zw.fARC6hGVGYsOgzkwtFf3tt1Zwi2yFuHa.Ib7jiByZaDEZIEe05c9Z.RNZDiliAVX0XQxgKDP0";
    extraGroups = [ "networkmanager" "wheel" "render" "video" "libvirt" ];
    packages = with pkgs; [
    ];
  };
  
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

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

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd glib libGL
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
        allowUnfree = true;
        cudaSupport = true;
      };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
#    extraPackages = with pkgs; [
#      mesa.drivers
#      libvdpau-va-gl
#      egl-wayland
#      libglvnd
#      (libedit.overrideAttrs (attrs: {postInstall = (attrs.postInstall or "") + ''ln -s $out/lib/libedit.so $out/lib/libedit.sp.2'';}))
#    ];
  
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
    nvtopPackages.nvidia
    
  ];

  environment.sessionVariables = {
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
  
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "25.05"; # Did you read the comment?

  nix.settings.auto-optimise-store = true;
  nix.gc = { 
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1m";
    };

}