{pkgs, pkgs-unstable, username, ...}: {  
  
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";

    folders = {
        sputnik-output = {
          id = "wm2fq-zmiiv";
          path = "/home/${username}/temp/comfy/basedir/output";
          #devices = [ "buldozer" "sputnik" ];
          ignorePerms = true;
        };
     };
    };
  };
}