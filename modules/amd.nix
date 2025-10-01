{pkgs, ...}: {
# In your configuration.nix
    #services.lact.enable = true; # Install and enable the lact monitor

    hardware.nvidia.open = false;

    services.xserver.videoDrivers = ["amdgpu"];
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
    };

  environment.systemPackages = 
  with pkgs; [
    #Packages
    rocminfo
  ];      

}
