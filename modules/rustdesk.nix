{pkgs, pkgs-unstable, ...}: {
   systemd.services."rustdesk" = {
        enable = true;
        path = with pkgs; [
        pkgs-unstable.rustdesk
        procps
        # This doesn't work since the version of sudo that will then be in the
        # path, won't have the setuid bit set
        # sudo
        # See the trick in `script` below modifying the path
        ];
        description = "RustDesk";
        requires = [ "network.target" ];
        after= [ "systemd-user-sessions.service" ];
        script = ''
        export PATH=/run/wrappers/bin:$PATH
        ${pkgs.rustdesk}/bin/rustdesk --service
        '';
        serviceConfig = {
        ExecStop = "${pkgs.procps}/pkill -f 'rustdesk --'";
        PIDFile = "/run/rustdesk.pid";
        KillMode = "mixed";
        TimeoutStopSec = "30";
        User = "root";
        LimitNOFILE = "100000";
        };
        wantedBy = [ "multi-user.target" ];
    };

          # Your configuration options here
    environment.systemPackages = [
        pkgs-unstable.rustdesk
   ];
}