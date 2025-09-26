{pkgs, ...}: {
  # for Nvidia GPU
  hardware.nvidia.datacenter.enable = true;
  
  hardware.graphics.enable = true;
  hardware.nvidia = {
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = false;
  };
}