{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        openai-whisper
    ];

    services.ollama = { 
        enable = true; 
        acceleration="cuda"; 
    };
}
