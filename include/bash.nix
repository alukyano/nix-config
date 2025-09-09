{ config, lib, pkgs, ... }:
    programs.bash = {
    enable = true;
    shellAliases = {
        ll = "ls -lh";
        update = "sudo nixos-rebuild switch -v";
    };
    initExtra = ''
        export MY_VARIABLE="hello_from_bashrc"
    '';
    };

}