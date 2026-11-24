{ config, pkgs, pkgs-unstable, ... }:

let
  # Пользователь, от имени которого будет работать прокси
  proxyUser = "zapret";
  # Очередь и fwmark берем напрямую из настроек модуля zapret2
  qnum = toString config.services.zapret2.firewall.queue;
  fwmark = toString config.services.zapret2.firewall.desyncFwmark;
in
{
  # 1. Выделенный системный пользователь для прокси
  users.users.${proxyUser} = {
    isSystemUser = true;
    group = proxyUser;
  };
  users.groups.${proxyUser} = { };

  # 2. Настройка zapret2 без глобального перехвата трафика хоста
  services.zapret2 = {
    enable = true;
    firewall.configureAutomatically = false;

    files = [ 
            "zapret-lib" 
            "zapret-antidpi" 
            "zapret-auto"
    ];

    profiles.default = {
      priority = 100;
      # Замените на ваши рабочие стратегии, подобранные через blockcheck2
      args = [
        "--filter-tcp=80,443"
        "--lua-desync=fake:blob=fake_default_tls:tcp_md5"
        "--lua-desync=multisplit:pos=1,sniext+1"
      ];
    };
  };

  # 3. Прокси-сервер (sing-box) с двумя inbound: SOCKS5:4444 и HTTP:3333
  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "socks";
          tag = "socks-in";
          listen = "0.0.0.0";
          listen_port = 4444;
          users = [
            {
              username = "gortis";
              password = "gortis";
            }
          ];
        }
        {
          type = "http";
          tag = "http-in";
          listen = "0.0.0.0";
          listen_port = 3333;
          users = [
            {
              username = "gortis";
              password = "gortis";
            }
          ];
        }
      ];
      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
      ];
    };
  };

  # Запускаем sing-box от имени нашего выделенного пользователя
  systemd.services.sing-box.serviceConfig = {
    User = proxyUser;
    Group = proxyUser;
    DynamicUser = pkgs.lib.mkForce false;
  };

  # 4. Точечное правило nftables: в zapret2 идет ТОЛЬКО трафик пользователя proxy-dpi
  networking.nftables = {
    enable = true;
    tables.zapret2-proxy-only = {
      family = "inet";
      content = ''
        chain output {
          type filter hook output priority mangle; policy accept;

          # Не трогаем локальный трафик (loopback и серые подсети)
          oifname "lo" accept
          ip daddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 127.0.0.0/8 } accept
          ip6 daddr { ::1/128, fc00::/7, fe80::/10 } accept

          # Игнорируем пакеты, уже обработанные/сгенерированные самим nfqws2
          meta mark & ${fwmark} == ${fwmark} accept

          # Заворачиваем в очередь zapret2 ТОЛЬКО исходящий трафик прокси-сервера
          meta skuid "${proxyUser}" counter queue num ${qnum} bypass
        }
      '';
    };
  };

  # 5. Открываем порты прокси только для доверенного интерфейса (например, LAN или WG)
#   networking.firewall.interfaces."eth0" = {
#     allowedTCPPorts = [ 3333 4444 ];
#     allowedUDPPorts = [ 4444 ]; # для SOCKS5 UDP ASSOCIATE
#   };
}