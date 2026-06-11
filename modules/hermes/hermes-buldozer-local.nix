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

    settings.model.default = "Qwen3.5-4B-heretic.Q4_K_S.gguf";
    settings.model.provider = "custom";
    settings.model.base_url = "http://192.168.55.61:8888/v1";
    settings.model.context_length = 75000;
    group = "users"; # Or your primary group (e.g., "your-username")
    extraDependencyGroups = [ "messaging" ];

    settings = {

    custom_providers = {
      name = "custom";
      base_url = "http://192.168.55.61:8888/v1";
      model = "Qwen3.5-4B-heretic.Q4_K_S.gguf";
      models."Qwen3.5-4B-heretic.Q4_K_S.gguf".context_length = 75000;
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
  
    settings.container = {
      resources.memory = "4g";
      resources.cpus = "1";
    };

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
      OPENAI_BASE_URL = "http://192.168.55.61:8888";
      TELEGRAM_PROXY = "socks5://192.168.55.61:4444";
      TELEGRAM_ALLOWED_USERS="97981052";
      TELEGRAM_HOME_CHANNEL="Alex";
    };
  };

   environment.systemPackages = [
    inputs.hermes-agent.packages.${pkgs.system}.default
    pkgs.docker
 ];
}