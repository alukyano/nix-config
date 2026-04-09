{
  pkgs,
  lib,
  config,
  ...
}: {
  services.hermes-agent = {
    enable = true;
    container.enable = true;
    #settings.model.default = "anthropic/claude-sonnet-4";
    #environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };

# services.hermes-agent.settings = {
#   #model.default = "anthropic/claude-sonnet-4";
#   toolsets = [ "all" ];
#   terminal = { backend = "local"; timeout = 180; };
#   display = { compact = false; personality = "kawaii"; };
#   memory = { memory_enabled = true; user_profile_enabled = true; };
# };
};