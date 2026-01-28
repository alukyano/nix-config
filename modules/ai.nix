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
}
