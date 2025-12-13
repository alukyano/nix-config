{ config, pkgs, ... }:

{
  # Enable OpenGL and Vulkan (essential for graphics)
  hardware.opengl.enable = true;

  # Enable X11 server (if using a DE/WM)
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ]; # Or "modesetting", "fbdev" if needed

  hardware.graphics.extraPackages = with pkgs; [
     vaapiIntel
     vaapiVdpau
     libvdpau-va-gl
     intel-media-driver
    # For 32-bit apps:
    # pkgs.driversi686Linux.intel-media-driver     
  ];  

  # For newer Alder Lake/Xe graphics, force kernel to use i915 driver if needed
  boot.kernelParams = [ "i915.force_probe=46a6" ]; # Replace 46a8 with your GPU's Device ID (from `lspci -nn | grep VGA`)

  # Enable Early KMS for less flicker (optional, might cause issues on some systems)
  # boot.initrd.kernelModules = [ "i915" ];
  # boot.kernelParams = [ "i915.enable_psr=0" ]; # Disable Panel Self Refresh if flickering

}
