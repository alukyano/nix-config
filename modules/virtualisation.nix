{pkgs, ...}: {

    boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd = {
        qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };

    environment.systemPackages = with pkgs; [
        podman-tui
        podman-compose 
        dive
        libguestfs-with-appliance
        libvirt
        libvirt-glib
        virt-manager
    ];

    programs = {
        virt-manager.enable = true;
    };

    virtualisation.containers.enable = true;
    virtualisation = {
        podman = {
        enable = true;
        # Create a 'docker' alias for podman, to use it as a drop in replacement
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other
        defaultNetwork.settings.dns_enabled = true;
        };
    };    

  }