{config, pkgs, ...}: {

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

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
    
  environment.systemPackages = 
  with pkgs; [
    #Packages
    nvtopPackages.nvidia
    cudaPackages.cudatoolkit
    linuxPackages.nvidia_x11
    linuxPackages.nvidiaPackages.latest
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