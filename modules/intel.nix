{pkgs, ...}: {
   boot.initrd.kernelModules = [ "i915" ];

   hardware.cpu.intel.updateMicrocode = true;
  
   hardware.opengl.extraPackages = with pkgs; [
     vaapiIntel
     vaapiVdpau
     libvdpau-va-gl
     intel-media-driver
   ];

}