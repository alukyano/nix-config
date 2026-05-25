{config, pkgs, pkgs-unstable, ...}: {  
  services.hermes-agent = {
    enable = true;
    container.enable = true;
    settings.model.default = "Qwen3.5-4B";
    settings.model.provider = "local";
    settings.model.base_url = "http://192.168.55.61:11111/v1";
    #environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };

services.hermes-agent.settings = {
  # model.default = "Qwen3.5-4B";
  # model.provider = "ollama-swap";
  # model.base_url = "http://192.168.55.61:11111/v1";
  toolsets = [ "all" ];
  terminal = { backend = "local"; timeout = 180; };
  display = { compact = false; personality = "kawaii"; };
  memory = { memory_enabled = true; user_profile_enabled = true; };
};
}