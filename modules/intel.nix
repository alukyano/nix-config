{pkgs, ...}: {

  #hardware.cpu.intel.updateMicrocode = true;
  
  hardware.graphics.extraPackages = with pkgs; [
     vaapiIntel
     vaapiVdpau
     libvdpau-va-gl
     intel-media-driver
  ];

}