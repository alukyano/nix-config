{pkgs, pkgs-unstable, ...}: {

    services.gitea = {
    enable = true;
    database.type = "sqlite";
    #settings.service.DISABLE_REGISTRATION = true;
    };

}