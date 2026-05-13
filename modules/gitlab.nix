{pkgs, pkgs-unstable, ...}: {

services.gitlab = {
  enable = true;
      # use git as user instead of the default "gitlab" so git+ssh works over git as well
  user = "git";
  group = "git";
  #host = "100.85.60.227";
  #port = 8080;
  https = false;

  databasePasswordFile = pkgs.writeText "dbPassword" "zgvcyfwdolbaebsxzcwr85l";
  initialRootPasswordFile = pkgs.writeText "rootPassword" "dakqdvp4ovdolbaebhksxer";
  secrets = {
    secretFile = pkgs.writeText "secret" "Aig5dolbeb";
    otpFile = pkgs.writeText "otpsecret" "Rdolba9mue";
    dbFile = pkgs.writeText "dbsecret" "we2dolbaebZ";
    jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
    activeRecordPrimaryKeyFile       = "/var/lib/gitlab/secrets/activeRecordPrimaryKey";
    activeRecordDeterministicKeyFile = "/var/lib/gitlab/secrets/activeRecordDeterministicKey";
    activeRecordSaltFile             = "/var/lib/gitlab/secrets/activeRecordSalt";
  };
  statePath = "/var/lib/gitlab";
  
  #databaseCreateLocally = false;
  #databaseHost = "";  # empty for local unix socket
  databaseName = "git";
  databaseUsername = "git";  # identical to service user so peer auth can be used

};

# services.nginx.streamConfig = ''
#     server {
#       listen [0.0.0.0]:8080;
#       proxy_pass http://unix:/run/gitlab/gitlab-workhorse.socket;
#     }
#   '';


services.nginx = {
  enable = true;
  recommendedProxySettings = true;
  virtualHosts = {
    localhost = {
      locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
    };
  };
};

services.postgresql = {
  ensureUsers = [{
    name = "git";
    ensureDBOwnership = true;
    }];
  ensureDatabases = [ "git" ];
  };


systemd.services.gitlab-backup.environment.BACKUP = "dump";

# # GitLab по IP БЕЗ домена
#   services.gitlab = {
#     enable = true;
#     host = "100.85.60.227";
#     port = 8080;      # ← КРИТИЧНО: твой IP!
#     https = false;               # Только HTTP
# # Пароли (рекомендуется вынести в отдельные файлы вне git)
#     databasePasswordFile = "/var/keys/gitlab/db_password";          # содержимое: любой сильный пароль
#     initialRootPasswordFile = "/var/keys/gitlab/root_password";     # содержимое: сильный пароль для root

#     # Секреты (можно сгенерировать один раз)
#     secrets = {
#       secretFile = pkgs.writeText "gitlab-secret" "This_is_very_secret_number_with_10_trailing_zero_0000000000";
#       otpFile = pkgs.writeText "gitlab-otp" "This_is_very_secret_number_with_10_trailing_one_1111111111";
#       dbFile = pkgs.writeText "gitlab-db-secret" "This_is_very_secret_number_for_db";
#       jwsFile = pkgs.runCommand "jws-key" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";

#       activeRecordPrimaryKeyFile       = "/var/lib/gitlab/secrets/activeRecordPrimaryKey";
#       activeRecordDeterministicKeyFile = "/var/lib/gitlab/secrets/activeRecordDeterministicKey";
#       activeRecordSaltFile             = "/var/lib/gitlab/secrets/activeRecordSalt";
#     };

#     # Основные возможности (включены по умолчанию в модуле)
#     databaseUsername = "gitlab";
#     databaseHost = "localhost";
#     databaseCreateLocally = true;   # создаёт БД автоматически

    # Registry (Container Registry) — включён по умолчанию
    # registry = {
    #   enable = true;
    #   port = 5005;                  # внутренний порт, доступен через http://IP:80
    #   externalPort = 5005;
    # };

    # Pages (GitLab Pages) — включён
    # pages = {
    #   enable = true;
    #   port = 8090;                  # внутренний порт
    # };

    # Дополнительно (рекомендуется)
    # backupPath = "/var/backup/gitlab";
    # smtp.enable = false;            # если нужен почтовый сервер — включите и настройте
  #};

  # Открываем порты в firewall
  #networking.firewall.allowedTCPPorts = [ 80 22 5005 ];  # 22 — для SSH git, 5005 — registry
  
  # Пароли и секреты
  #   initialRootPasswordFile = "/etc/nixos/gitlab-root-pass";
  #   secrets = {
  #     dbFile = "/etc/nixos/gitlab-db";
  #     secretFile = "/etc/nixos/gitlab-secret";
  #     otpFile = "/etc/nixos/gitlab-otp";
  #     jwsFile = "/etc/nixos/gitlab-jws";
  #   };
  # };

  # # Директория бэкапов
  # systemd.tmpfiles.rules = [
  #   "d /var/backups/gitlab 0755 gitlab gitlab - -"
  # ];

}