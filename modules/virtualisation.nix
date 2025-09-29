{pkgs, ...}: {
   environment.systemPackages = with pkgs; [
         podman-tui
         podman-compose 
         dive
    ];

    programs = {
        virt-manager.enable = true;
    };

    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd = {
        qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
    
    hardware.nvidia-container-toolkit = {
        enable = true;
        mount-nvidia-executables = false;
        suppressNvidiaDriverAssertion = true;
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