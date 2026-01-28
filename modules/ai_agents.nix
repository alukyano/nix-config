{pkgs, pkgs-llm, ...}: {
    environment.systemPackages = with pkgs; [
    pkgs-llm.claude-code
    pkgs-llm.opencode
    pkgs-llm.gemini-cli
  ];
}
