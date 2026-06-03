{config, pkgs, lib, pkgs-unstable, username, ...}: {  
  services.hermes-agent = {
    enable = true;
    container.enable = true;

    environmentFiles = [ "/var/lib/hermes/env" ];
    # settings.model.default = "Qwen3.5-4B";
    # settings.model.provider = "local";
    # settings.model.base_url = "http://192.168.55.61:11111/v1";
    #environmentFiles = [ config.sops.secrets."hermes-env".path ];
    #user = "${username}";
    group = "users"; # Or your primary group (e.g., "your-username")
    #extraDependencyGroups = [ "messaging" ];
 

  settings = {
    model = {
      povider = "custom";
      base_url = "http://192.168.55.61:8888/v1";
      default = "Qwen3.5-4B-heretic.Q4_K_S.gguf";
      context_length = 75000;
    };

    custom_providers = {
      name = [ "custom" ];
      base_url = "http://192.168.55.61:8888/v1";
      model = "Qwen3.5-4B-heretic.Q4_K_Sgguf";
      models."Qwen3.5-4B-heretic.Q4_K_S.gguf".context_length = 75000;
    };

    toolsets = [ "all" ];
    max_turns = 100;
    terminal = { backend = "docker"; timeout = 180; };
    display = { compact = false; personality = "kawaii"; };
    memory = { memory_enabled = true; user_profile_enabled = true; };
    agent = { max_turns = 100; verbose = false; };
    
    # gateway = {
    #   platform = "telegram";
    #   token = builtins.readFile "${config.home.homeDirectory}/projects/nix-config/secrets/tgtoken.txt";
    #   transport_kwargs.proxy_url = "socks5://192.168.55.61:4444";
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
      container = {
        image = "ubuntu:24.04";
        backend = "docker";
        hostUsers = [ "${username}" ];
        extraVolumes = [ "/home/alukyano/Hermes:/Hermes:rw" ];
        #extraOptions = [ "--gpus" "all" ];
      };

      # ── Service tuning ─────────────────────────────────────────────────
      addToSystemPackages = true;
      extraArgs = [ "--verbose" ];
      restart = "always";
      restartSec = 5;
    };

    extraPackages = with pkgs; [docker jq ripgrep curl];

    environment = {
      HERMES_DEFAULT_PROVIDER = "custom";
      OPENAI_BASE_URL = "http://192.168.55.61:8888";
      TELEGRAM_PROXY = "socks5://192.168.55.61:4444";
      TELEGRAM_BOT_TOKEN="";
      TELEGRAM_ALLOWED_USERS="97981052";
      TELEGRAM_HOME_CHANNEL="Alex";
    };
  };
}