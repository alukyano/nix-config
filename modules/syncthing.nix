{pkgs, pkgs-unstable, username, ...}: {  
  
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
        gui = {
          user = "${username}";
          password = "345a79-05445.4s4";
        };
        devices = {
          "msc-xalukyano" = { id = "J2KLOD6-BKGH73X-BNYUUI2-FGFWD7R-BYCTOZS-CYBZLI5-WFQVSCH-IOZY4AG"; };
          "buldozer" = { id = "MFXZJ74-NC24DEF-JLLZWFH-EZ6U2RE-2H6KQZ6-WGX6VKQ-Y5ONOQB-5PYZ4AI"; };
          "sputnik" = { id = "5IW27RD-VIVY3VB-LCIRJOX-72SB4X3-B7OAU3H-TDII57E-BKYDJXD-WUOMMQB"; };
          "moon" = { id = "7JIOH7R-LAZMVW6-EITU7WR-LKKJNZD-FK2A4EN-PYUABPM-LCRNNJN-5THTZAY"; };
        };
        folders = {
          "Shared" = {
            path = "/home/${username}/Shared";
            devices = [ "msc-xalukyano" "buldozer" "sputnik" "moon" ];
            ignorePerms = true; # Enable file permission syncing
          };
        };
      };
  };
}