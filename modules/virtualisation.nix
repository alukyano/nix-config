{pkgs, username, ...}: {

    boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

    programs = {
        virt-manager.enable = true;
    };

    virtualisation.containers.enable = true;


  virtualisation = {
    libvirtd = {
      enable = true;
      package = with pkgs.stable; libvirt;
      qemu = {
        vhostUserPackages = with pkgs; [ virtiofsd ];
        package = with pkgs.stable; qemu;
        swtpm = {
          enable = false;
          package = with pkgs.stable; swtpm;
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };
  users.users.${username}.extraGroups = [ "libvirtd" ];
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    # winboat
    freerdp
    dive
    libguestfs-with-appliance
    libvirt
    libvirt-glib
    virt-manager
  ];

} 
