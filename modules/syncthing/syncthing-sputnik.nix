{pkgs, pkgs-unstable, username, ...}: {  
  
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      user = "alukyano";
      dataDir = "/home/alukyano";
      configDir = "/home/alukyano/.config/syncthing";

    folders = {
        sputnik-output = {
          id = "wm2fq-zmiiv";
          path = "/home/alukyano/temp/comfy/basedir/output";
          #devices = [ "buldozer" "sputnik" ];
          ignorePerms = true;
        };
     };
    };
  };
}