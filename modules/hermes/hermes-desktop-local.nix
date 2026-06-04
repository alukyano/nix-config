{config, pkgs, lib, pkgs-unstable, inputs, username, ...}: {  
  
  services.hermes-agent = {
    enable = true;
    #container.enable = true;

    #environmentFiles = [ "/var/lib/hermes/env" ];
    settings.model.default = "hermes-qwen3.5-35b-a3b-Q4_K_M.gguf";
    settings.model.provider = "custom";
    settings.model.base_url = "http://192.168.55.56:9148/v1";
    settings.model.context_length = 200000;
    #environmentFiles = [ config.sops.secrets."hermes-env".path ];
    #user = "alukyano";
    group = "alukyano"; # Or your primary group (e.g., "your-username")
    #extraDependencyGroups = [ "messaging" ];
 

    settings = {
  #   model = {
  #     povider = "custom";
  #     base_url = "http://192.168.55.56:9148/v1";
  #     default = "hermes-qwen3.5-35b-a3b-Q4_K_M.gguf";
  #     context_length = 200000;
  #   };

    custom_providers = {
      name = [ "custom" ];
      base_url = "http://192.168.55.56:9148/v1";
      model = "hermes-qwen3.5-35b-a3b-Q4_K_M.gguf";
      models."hermes-qwen3.5-35b-a3b-Q4_K_M.gguf".context_length = 200000;
    };

    toolsets = [ "all" ];
    max_turns = 100;
    terminal = { backend = "local"; timeout = 180; };
    display = { compact = false; personality = "kawaii"; };
    memory = { memory_enabled = true; user_profile_enabled = true; };
    agent = { max_turns = 100; verbose = false; };
    
    gateway = {
      platform = "telegram";
      #token = lib.strings.removeSuffix "\n" (builtins.readFile ../secrets/tgtoken.txt);
      token = builtins.readFile ./secrets/tgtoken_desktop.txt;
      transport_kwargs.proxy_url = "socks5://192.168.55.56:4444";
    };
      # # ── Documents ──────────────────────────────────────────────────────
      # documents = {
      #   "USER.md" = ./documents/USER.md;
      # };

      # # ── MCP Servers ────────────────────────────────────────────────────
      # mcpServers.filesystem = {
      #   command = "npx";
      #   args = [ "-y" "@modelcontextprotocol/server-filesystem" "/data/workspace" ];
      # };

      # # ── Container options ──────────────────────────────────────────────
      # container = {
      #   image = "ubuntu:24.04";
      #   backend = "docker";
      #   hostUsers = [ "${username}" ];
      #   extraVolumes = [ "/home/alukyano/Hermes:/Hermes:rw" ];
      #   #extraOptions = [ "--gpus" "all" ];
      # };

      # ── Service tuning ─────────────────────────────────────────────────
      addToSystemPackages = true;
      extraArgs = [ "--verbose" ];
      restart = "always";
      restartSec = 5;
    };

    extraPackages = with pkgs; [
        bat
        openssh
        diffutils
        gnused
        gawk
        binutils
        nettools
        iputils
        jq 
        ripgrep 
        curl
        docker
        docker-compose
        kubectl

        python313
        jdk_headless
        go
        perl
        gcc
        gnumake
        cmake
        nodejs
        bash
        git
        gdal
        tmux

        ffmpeg
        yt-dlp   
        sox
        lame
        flac
        imagemagick
        opencv
        aria2
        tcpdump
        nmap
        ngrep
        tshark
        netcat-gnu
        lynx
        links2
        browsh

      ];

    extraPythonPackages = with pkgs; [ 
      python313Packages.numpy 
      python313Packages.pandas
      python313Packages.geopandas
      python313Packages.gdal
      python313Packages.pillow
      python313Packages.av
      python313Packages.sh
      python313Packages.uv
      python313Packages.psutil
      python313Packages.aiohttp
      python313Packages.pyyaml
      python313Packages.scipy
      python313Packages.opencv4
      python313Packages.pyshark
      ];

    environment = {
      HERMES_DEFAULT_PROVIDER = "custom";
      OPENAI_BASE_URL = "http://192.168.55.56:9148";
      TELEGRAM_PROXY = "socks5://192.168.55.56:4444";
      TELEGRAM_BOT_TOKEN = builtins.readFile ./secrets/tgtoken_desktop.txt;
      TELEGRAM_ALLOWED_USERS="97981052";
      TELEGRAM_HOME_CHANNEL="Alex";
    };
  };

#   users.users.hermes = {
#     extraGroups = [ "docker" "users" ];
#     packages = with pkgs; [
#       docker
#     ];
#   };

   environment.systemPackages = [
    inputs.hermes-agent.packages.${pkgs.system}.default
 ];
}