{pkgs, ...}: {
  # for Nvidia GPU
  #hardware.nvidia.datacenter.enable = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
    
  environment.systemPackages = 
  with pkgs; [
    #Packages
    nvtopPackages.nvidia
  ];

}