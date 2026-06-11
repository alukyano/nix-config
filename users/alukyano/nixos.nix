{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  users.users.alukyano = {
    isNormalUser = true;
    description = "Alex";   
    extraGroups = [ "networkmanager" "wheel" "render" "video" "libvirt" "docker" "hermes"];
    # alukyano authorizedKeys
    #openssh.authorizedKeys.keys = [
    #  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJx3Sk20pLL1b2PPKZey2oTyioODrErq83xG78YpFBoj alukyano@alukyano"
    #];
  };

}
