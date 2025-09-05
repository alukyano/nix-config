{ config, lib, pkgs, ... }:
{
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
    };
    
  environment.systemPackages = with pkgs; [
   #Packages
   nvtopPackages.nvidia
  ];

}