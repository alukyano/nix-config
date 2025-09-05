{ config, lib, pkgs, ... }:
{
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        #powerManagement.finegrained = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    
    services.xserver.videoDrivers = [ "nvidia" ];  
    
  environment.systemPackages = 
  let
    nvidiaEnabled = lib.elem "nvidia" config.services.xserver.videoDrivers;
  in
  (with pkgs; [
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in 
   pkgs.buildFHSEnv (base // {
     name = "fhs";
     targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config]; 
     profile = "export FHS=1"; 
     runScript = "fish"; 
     extraOutputsToInstall = ["dev"];
   }))
   #Packages

  ])
  ++ lib.optionals nvidiaEnabled [
    (config.hardware.nvidia.package.settings.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.vulkan-headers ];
    }))
  ];


}