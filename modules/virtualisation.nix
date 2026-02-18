{config, pkgs, username, ...}: {

  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

  programs = {
        #virt-manager.enable = true;
  };

  virtualisation.containers.enable = true;
  virtualisation.virtualbox.host.enable = true;


  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [
        "virbr0"
        "br0"
      ];     
      package = with pkgs; libvirt;
      qemu = {
        vhostUserPackages = with pkgs; [ virtiofsd ];
        package = with pkgs; qemu;
        swtpm = {
          enable = false;
          package = with pkgs; swtpm;
        };
      };
    };
    spiceUSBRedirection.enable = true;

    appvm.enable = true;
    appvm.user = username;
  };

  users.users.${username}.extraGroups = [ "libvirtd" ];
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;
  
  environment.systemPackages = with pkgs; [
    freerdp
    dive
    libguestfs-with-appliance
    libvirt
    libvirt-glib
    virt-manager
    virtualboxKvm
  ];

} 
