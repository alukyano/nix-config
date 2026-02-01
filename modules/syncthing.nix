{pkgs, pkgs-unstable, username, ...}: {  
  
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
        gui = {
          user = "${username}";
          password = "mypassword";
        };
        devices = {
          "msc-xalukyano" = { id = "DEVICE-ID-GOES-HERE"; };
          "buldozer" = { id = "DEVICE-ID-GOES-HERE"; };
          "sputnik" = { id = "DEVICE-ID-GOES-HERE"; };
          "moon" = { id = "DEVICE-ID-GOES-HERE"; };
        };
        folders = {
          "Shared" = {
            path = "/home/${username}/Shared";
            devices = [ "msc-xalukyano" "buldozer" "sputnik" "moon" ];
            ignorePerms = false; # Enable file permission syncing
          };
        };
      };
  };
}