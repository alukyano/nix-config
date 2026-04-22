{pkgs, pkgs-unstable, username, ...}: {

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.host.addNetworkInterface = false;
  virtualisation.virtualbox.host.enableKvm = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = false;
  virtualisation.virtualbox.guest.clipboard = true;
  users.extraGroups.vboxusers.members = [username];
  virtualisation.virtualbox.host.enableHardening = false;

  # environment.systemPackages = [
  #     pkgs.virtualbox
  #   ];  
}