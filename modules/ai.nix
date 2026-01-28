{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        openai-whisper
        lmstudio
        vllm
    ];

    services.ollama = { 
        enable = true; 
        acceleration="cuda"; 
    };

    environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    claude-code
    opencode
    gemini-cli
    # ... other tools
  ];
}
