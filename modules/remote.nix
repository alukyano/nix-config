{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        # Remote Connect Applications
        #realvnc-vnc-viewer
        remmina
        x11spice
    ];
}