{pkgs, pkgs-unstable, ...}: {

    environment.systemPackages = [
        pkgs-unstable.vm-curator
   ];
  
}
