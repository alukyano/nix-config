{pkgs, pkgs-unstable, ...}: {

# GitLab по IP БЕЗ домена
  services.gitlab = {
    enable = true;
    host = "100.85.60.227";      # ← КРИТИЧНО: твой IP!
    https = false;               # Только HTTP

    # Пароли и секреты
    initialRootPasswordFile = "/etc/nixos/gitlab-root-pass";
    secrets = {
      dbFile = "/etc/nixos/gitlab-db";
      secretFile = "/etc/nixos/gitlab-secret";
      otpFile = "/etc/nixos/gitlab-otp";
      jwsFile = "/etc/nixos/gitlab-jws";
    };
  };

  # Директория бэкапов
  systemd.tmpfiles.rules = [
    "d /var/backups/gitlab 0755 gitlab gitlab - -"
  ];

}