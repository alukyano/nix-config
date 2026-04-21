{pkgs, pkgs-unstable, username, ...}: {

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
  users.extraGroups.vboxusers.members = [username];
  virtualisation.virtualbox.host.enableHardening = false;

  environment.systemPackages = [
      pkgs-unstable.virtualbox
    ];  
}