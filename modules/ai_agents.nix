{pkgs, llm-agents, ...}: {

  environment.systemPackages = with llm-agents.packages.x86_64-linux; [
    claude-code
    opencode
    gemini-cli
  ];

} 