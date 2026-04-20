{pkgs, pkgs-unstable, ...}: {  
  services.hermes-agent = {
    enable = true;
    container.enable = true;
    settings.model.base_url = "http://127.0.0.1:1234/v1";
    settings.model.default = "hermes-qwen3.5-35b-a3b";
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };

# services.hermes-agent.settings = {
#   #model.default = "anthropic/claude-sonnet-4";
#   toolsets = [ "all" ];
#   terminal = { backend = "local"; timeout = 180; };
#   display = { compact = false; personality = "kawaii"; };
#   memory = { memory_enabled = true; user_profile_enabled = true; };
# };
}