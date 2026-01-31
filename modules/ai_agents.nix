{pkgs, llm-agents, ...}: {

  environment.systemPackages = with pkgs; [
    claude-code
    opencode
  ];

} 