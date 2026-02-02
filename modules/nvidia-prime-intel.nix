{config, pkgs, ...}: {
  # for Nvidia GPU
  # hardware.nvidia.datacenter.enable = true;

  #boot.kernelPackages = pkgs.linuxPackages;
  #boot.kernelPackages.nvidia_x11 = true;

  services.xserver.videoDrivers = [
    "modesetting"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  hardware.nvidia.open = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # boot.initrd.kernelModules = [ "i915" ];
  # boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" ];

  # services.xserver.videoDrivers = ["intel"];
  # hardware.graphics.enable = true;
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   #powerManagement.finegrained = true;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
    
  environment.systemPackages = 
  with pkgs; [
    #Packages
    nvtopPackages.nvidia
    cudaPackages.cudatoolkit
    linuxPackages.nvidia_x11
    linuxPackages.nvidiaPackages.stable
  ];

  hardware.graphics.extraPackages = with pkgs; [
     intel-vaapi-driver   #vaapiIntel
     libva-vdpau-driver   #vaapiVdpau
     libvdpau-va-gl
     intel-media-driver
  ];

  hardware.nvidia-container-toolkit = {
      enable = true;
      mount-nvidia-executables = false;
      suppressNvidiaDriverAssertion = true;
  };
}