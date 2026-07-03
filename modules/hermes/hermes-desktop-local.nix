{config, pkgs, lib, pkgs-unstable, inputs, username, ...}: {  
  
  sops = {
    secrets."hermes-env" = { format = "yaml"; };
  };

  services.hermes-agent = {
    enable = true;
    #container.enable = true;

    environmentFiles = [
      config.sops.secrets."hermes-env".path
    ];

    settings.model.default = "Qwen3.6-35B-A3B-Uncensored-Genesis-APEX.gguf";
    settings.model.provider = "custom";
    settings.model.base_url = "http://192.168.55.56:9148/v1";
    settings.model.context_length = 262144;
    group = "users"; # Or your primary group (e.g., "your-username")
    extraDependencyGroups = [ "messaging" ];

    settings = {

    custom_providers = {
      name = "custom";
      base_url = "http://192.168.55.56:9148/v1";
      model = "Qwen3.6-35B-A3B-Uncensored-Genesis-APEX.gguf ";
      models."./Qwen3.6-35B-A3B-Uncensored-Genesis-APEX.gguf".context_length = 262144;
    };

    toolsets = [ "all" ];
    max_turns = 100;
    terminal = { backend = "local"; timeout = 180; };
    display = { compact = false; personality = "kawaii"; };
    memory = { memory_enabled = true; user_profile_enabled = true; };
    #agent = { max_turns = 100; verbose = false; };
    
    settings.agent = {
      max_turns = 100;
      verbose = false;
      cache_enabled = true;
    };
  
    # settings.container = {
    #   resources.memory = "8g";
    #   resources.cpus = "4";
    # };

    # gateway = {
    #   platform = "telegram";
    #   #token = lib.strings.removeSuffix "\n" (builtins.readFile ../secrets/tgtoken.txt);
    #   token = builtins.readFile ./secrets/tgtoken_desktop.txt;
    #   transport_kwargs.proxy_url = "socks5://192.168.55.56:4444";
    # };
    # gateway = {
    #   platform = "irc";
    #   enabled = true;
    #   host = "84.54.47.152";
    #   port = 6667;
    #   use_ssl = false;
    #   nickname = "hermes-desktop";
    #   channels = [ "#hermes-desktop" ];
    #   password = "mordor";
    # };    
      # # ── Documents ──────────────────────────────────────────────────────
      # documents = {
      #   "USER.md" = ./documents/USER.md;
      # };

      # # ── MCP Servers ────────────────────────────────────────────────────
      # mcpServers.filesystem = {
      #   command = "npx";
      #   args = [ "-y" "@modelcontextprotocol/server-filesystem" "/data/workspace" ];
      # };

      # ── Container options ──────────────────────────────────────────────
      # container = {
      #   image = "ubuntu:24.04";
      #   backend = "docker";
      #   hostUsers = [ "${username}" ];
      #   extraVolumes = [ "/home/alukyano/Hermes:/Hermes:rw" ];
      #   #extraOptions = [ "--gpus" "all" ];
      #   extraOptions = [ 
      #       "-v" "/run/docker.sock:/run/docker.sock"
      #       "-v" "/run/dbus:/run/dbus"
      #     ];
      # };

      # ── Service tuning ─────────────────────────────────────────────────
      addToSystemPackages = true;
      extraArgs = [ "--verbose" ];
      restart = "always";
      restartSec = 5;
    };


  extraPackages = with pkgs; [
    bat openssh diffutils gnused gawk binutils nettools iputils
    jq ripgrep curl docker docker-compose kubectl
    python313 jdk_headless go perl gcc gnumake cmake
    nodejs bash git gdal tmux ffmpeg yt-dlp sox lame
    flac imagemagick opencv aria2 tcpdump nmap ngrep
    tshark netcat-gnu lynx links2 browsh
  ];
  
  extraPythonPackages = with pkgs; [
    python313Packages.numpy
    python313Packages.pandas
    python313Packages.geopandas
    python313Packages.pillow
    python313Packages.av
    python313Packages.sh
    python313Packages.uv
    python313Packages.psutil
    python313Packages.aiohttp
    python313Packages.pyyaml
    python313Packages.scipy
    python313Packages.pyshark
  ];


    environment = {
      HERMES_DEFAULT_PROVIDER = "custom";
      OPENAI_BASE_URL = "http://192.168.55.56:9148";
      TELEGRAM_PROXY = "socks5://192.168.55.56:4444";
      TELEGRAM_ALLOWED_USERS="97981052";
      TELEGRAM_HOME_CHANNEL="Alex";
      # IRC_SERVER="84.54.47.152";
      # IRC_USE_TLS="false";
      # IRC_PORT="6667";
      # IRC_NICKNAME="hermes-desktop";
      # IRC_CHANNEL="hermes-desktop";
      # IRC_SERVER_PASSWORD="mordor";
      # IRC_ALLOW_ALL_USERS="false";
      # IRC_ALLOWED_USERS="alukyano";
      # TELEGRAM_PROXY = "socks5://192.168.55.56:4444";
      # TELEGRAM_BOT_TOKEN = builtins.readFile ./secrets/tgtoken_desktop.txt;
      # TELEGRAM_ALLOWED_USERS="97981052";
      # TELEGRAM_HOME_CHANNEL="Alex";
    };
  };

   environment.systemPackages = [
    inputs.hermes-agent.packages.${pkgs.system}.default
    pkgs.docker
 ];
}