{pkgs, pkgs-unstable, ...}: {
    environment.systemPackages = with pkgs; [
        openai-whisper
        pkgs-unstable.lmstudio
        pkgs-unstable.vllm
        pkgs-unstable.koboldcpp
    ];

    services.ollama = { 
        enable = true; 
        #acceleration="cuda"; 
    };
}
