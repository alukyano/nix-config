{pkgs, pkgs-unstable, ...}: {

    services.gitea = {
        enable = true;
        database.type = "sqlite3";
        #settings.service.DISABLE_REGISTRATION = true;
    };

}