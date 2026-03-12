{pkgs, pkgs-unstable, ...}: {

# GitLab по IP БЕЗ домена
  services.gitlab = {
    enable = true;
    host = "100.85.60.227";      # ← КРИТИЧНО: твой IP!
    https = false;               # Только HTTP
    externalPort = 80;
    
    # PostgreSQL база (встроенная)
    database.type = "pq";
    
    # Пароли и секреты
    initialRootPasswordFile = "/etc/nixos/gitlab-root-pass";
    secrets = {
      dbFile = "/etc/nixos/gitlab-db";
      secretFile = "/etc/nixos/gitlab-secret";
      otpFile = "/etc/nixos/gitlab-otp";
      jwsFile = "/etc/nixos/gitlab-jws";
    };
  };

  # БЭКАП GitLab (ежедневно в 3:00)
  services.gitlabBackup = {
    enable = true;
    compression = "gzip";
    age = 30;  # 30 дней
  };

  # Директория бэкапов
  systemd.tmpfiles.rules = [
    "d /var/backups/gitlab 0755 gitlab gitlab - -"
  ];

}