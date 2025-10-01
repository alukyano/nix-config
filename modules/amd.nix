{pkgs, ...}: {
  # for Nvidia GPU
  #hardware.nvidia.datacenter.enable = true;
# In your configuration.nix
    services.lact.enable = true; # Install and enable the lact monitor

    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk # For Vulkan support
        mesa # For OpenCL support
        lact # For monitoring utilities
        rocmPackages.clr
        rocmPackages.rocminfo
        rocmPackages.rocm-smi
        rocmPackages.rocm-runtime
        ];
      DRI.enable = true; # Enable DRI for 3D acceleration
    };

  environment.systemPackages = 
  with pkgs; [
    #Packages
    
  ];      

}
