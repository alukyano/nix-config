{config, pkgs, lib, pkgs-unstable, inputs, username, ...}: {  

  sops = {
    secrets."hermes-env" = { format = "yaml"; };
  };

  services.hermes-agent = {
    enable = true;
    container.enable = true;

    #environmentFiles = [ "/var/lib/hermes/env" ];
    environmentFiles = [
      config.sops.secrets."hermes-env".path
    ];
    
    settings.model.default = "hermes-qwen3.5-35b-a3b-Q4_K_M.gguf";
    settings.model.provider = "custom";
    settings.model.base_url = "http://192.168.55.56:9148/v1";
    settings.model.context_length = 200000;
    #environmentFiles = [ config.sops.secrets."hermes-env".path ];
    #user = "alukyano";
    group = "users"; # Or your primary group (e.g., "your-username")
    extraDependencyGroups = [ "messaging" ];
 

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
    terminal = { backend = "docker"; timeout = 180; };
    display = { compact = false; personality = "kawaii"; };
    memory = { memory_enabled = true; user_profile_enabled = true; };
    agent = { max_turns = 100; verbose = false; };
    
    # gateway = {
    #   platform = "telegram";
    #   #token = lib.strings.removeSuffix "\n" (builtins.readFile ../secrets/tgtoken.txt);
    #   token = (builtins.readFile config.sops.secrets.telegram_key.path);
    #   allowed_users="97981052";
    #   transport_kwargs.proxy_url = "socks5://192.168.55.56:4444";
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
        hostUsers = [ "alukyano" ];
        extraVolumes = [ "/home/alukyano/Hermes:/Hermes:rw" "/var/run/docker.pid:/var/run/docker.pid" "/var/run/docker.sock:/var/run/docker.sock" ];
        extraPackages = with pkgs; [ docker ]; 
        extraOptions = [ 
            "-v" "/run/docker.sock:/run/docker.sock"
            "-v" "/run/dbus:/run/dbus"
        ];
        #extraOptions = [ "--gpus" "all" ];
      };

      # ── Service tuning ─────────────────────────────────────────────────
      addToSystemPackages = true;
      extraArgs = [ "--verbose" ];
      restart = "always";
      restartSec = 5;
    };

    extraPackages = with pkgs; [jq ripgrep docker curl];

    environment = {
      HERMES_DEFAULT_PROVIDER = "custom";
      OPENAI_BASE_URL = "http://192.168.55.56:9148";
      TELEGRAM_PROXY = "socks5://192.168.55.56:4444";
      #TELEGRAM_BOT_TOKEN = config.sops.templates."telegram_key".content;
      TELEGRAM_ALLOWED_USERS="97981052";
      TELEGRAM_HOME_CHANNEL="Alex";
    };

    environment.variables = {
      DOCKER_HOST = "unix:///var/run/docker.sock";
      PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/run/current-system/sw/bin";
    };
  };

  users.users.hermes = {
    extraGroups = [ "docker" "users" ];
    packages = with pkgs; [
      docker
    ];
  };

   environment.systemPackages = [
    inputs.hermes-agent.packages.${pkgs.system}.default
 ];
}