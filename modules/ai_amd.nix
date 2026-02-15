{pkgs, pkgs-unstable, ...}: {
    environment.systemPackages = with pkgs; [
        pkgs-unstable.openai-whisper
        pkgs-unstable.lmstudio
        pkgs-unstable.vllm
        pkgs-unstable.koboldcpp
        pkgs-unstable.ollama-rocm
        pkgs-unstable.llama-cpp
        pkgs-unstable.stable-diffusion-cpp
        pkgs-unstable.llama-swap
    ];
    services.ollama.enable = true;
}