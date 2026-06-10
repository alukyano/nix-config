{config, pkgs, ...}: {

  services.xserver.videoDrivers = [
    "modesetting"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  hardware.nvidia.open = false;
  #   # Force the 580 driver version
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production.overrideAttrs {
  #   version = "580.142.04"; # (Optional) adjust to your exact known 580.xx sub-version
  #   src = pkgs.fetchurl {
  #     url = "https://nvidia.com";
  #     sha256 = "1111111111111111111111111111111111111111111111111111"; # Replace with actual SHA256
  #   };
  # };

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
    
  environment.systemPackages = 
  with pkgs; [
    nvtopPackages.nvidia
    cudaPackages.cudatoolkit
    #linuxPackages.nvidia_x11
    linuxPackages.nvidiaPackages.legacy_580
    #legacy_580
  ];




  #boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    
  hardware.graphics.extraPackages = with pkgs; [
     intel-vaapi-driver   #vaapiIntel
     libva-vdpau-driver   #vaapiVdpau
     libvdpau-va-gl
     intel-media-driver
  ];

  hardware.nvidia-container-toolkit = {
      enable = true;
      mount-nvidia-executables = true;
      suppressNvidiaDriverAssertion = true;
  };
}