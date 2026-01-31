{pkgs, pkgs-unstable, ...}: {
    environment.systemPackages = with pkgs; [
        pkgs-unstable.openai-whisper
        pkgs-unstable.lmstudio
        pkgs-unstable.vllm
        pkgs-unstable.koboldcpp
        pkgs-unstable.ollama-rocm
    ];
    services.ollama.enable = true;
}