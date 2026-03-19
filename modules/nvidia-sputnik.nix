{config, pkgs, ...}: {
  services.xserver.videoDrivers = [
    "amdgpu"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

   hardware.nvidia.prime = {
     offload.enable = true;
     offload.enableOffloadCmd = true;
     nvidiaBusId = "PCI:1:0:0";
     amdgpuBusId = "PCI:7:0:0"; # If you have an AMD iGPU
  };

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
    rocmPackages.rpp
    rocmPackages.clr
    rocmPackages.hipcc
    rocmPackages.rocm-smi
    rocmPackages.rocm-runtime
    mesa-demos
  ];

  hardware.graphics.extraPackages = with pkgs; [
        mesa # For OpenCL support
        lact # For monitoring utilities
        rocmPackages.clr
        rocmPackages.rocminfo
        rocmPackages.rocm-smi
        rocmPackages.rocm-runtime
  ];

  hardware.nvidia-container-toolkit = {
      enable = true;
      mount-nvidia-executables = false;
      suppressNvidiaDriverAssertion = true;
  };
}