{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  users.users.onaykula = {
    isNormalUser = true;
    description = "onaykula";   
    extraGroups = [ "networkmanager" "wheel" "render" "video" "libvirt" "hermes"];
  };
}
