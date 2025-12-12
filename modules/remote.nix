{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        # Remote Connect Applications
        pkgs.realvnc-vnc-viewer
        pkgs.remmina
    ];
}