{pkgs, pkgs-unstable, ...}: {

    environment.systemPackages = [
        pkgs-unstable.classic-image-viewer 
   ];
  
}
