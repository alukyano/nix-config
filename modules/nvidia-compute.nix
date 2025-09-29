{pkgs, ...}: {
  # for Nvidia GPU
  #hardware.nvidia.enable = true;
  
  services.xserver.videoDrivers = ["intel"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = false;
    powerManagement.enable = false;
    #powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
    
  environment.systemPackages = 
  with pkgs; [
    #Packages
    nvtopPackages.nvidia
    cudaPackages.cudatoolkit
    linuxPackages.nvidia_x11
  ];
}