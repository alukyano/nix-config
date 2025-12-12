{ config, pkgs, lib, ... }:

with lib;

{


  
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
  };
  
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      #nvidiaPersistenced = true;

      #---------------------------------------------------------------------
      # Enable the nvidia settings menu
      #---------------------------------------------------------------------
      nvidiaSettings = true;

      #---------------------------------------------------------------------
      # Enable power management (do not disable this unless you have a reason to).
      # Likely to cause problems on laptops and with screen tearing if disabled.
      #---------------------------------------------------------------------
      powerManagement.enable = true;         # Fix Suspend issue

      #---------------------------------------------------------------------
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      #---------------------------------------------------------------------
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    
    graphics = {
      enable = true;
      enable32Bit = true; 

      #---------------------------------------------------------------------
      # Install additional packages that improve graphics performance and compatibility.
      #---------------------------------------------------------------------
      extraPackages = with pkgs; [        
        
        intel-media-driver      # LIBVA_DRIVER_NAME=iHD
        libvdpau-va-gl
        nvidia-vaapi-driver
        intel-vaapi-driver                 # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libva-vdpau-driver
        vulkan-validation-layers
      ];

    };
  };

  #---------------------------------------------------------------------
  # OpenRGB && X Server Video Drivers Configuration
  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  #---------------------------------------------------------------------
  services = {
    hardware.openrgb = {
      enable = true;
      motherboard = "intel";
      package = pkgs.openrgb-with-all-plugins;
    };
    xserver.videoDrivers = [ "nvidia" "i915" ];
  };

  #---------------------------------------------------------------------
  # Set environment variables related to NVIDIA graphics:
  #---------------------------------------------------------------------
  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  #---------------------------------------------------------------------
  # Packages related to NVIDIA graphics:
  #---------------------------------------------------------------------
  environment.systemPackages = with pkgs; [

    clinfo
    gwe
    nvtopPackages.nvidia
    virtualglLib
    vulkan-loader
    vulkan-tools

  ];

}
