{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        openai-whisper
        lmstudio
        vllm
        koboldcpp
        ollama-cpu
    ];
}
