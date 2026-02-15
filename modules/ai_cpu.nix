{pkgs, pkgs-unstable, ...}: {
    environment.systemPackages = [
        pkgs-unstable.openai-whisper
        pkgs-unstable.lmstudio
        pkgs-unstable.vllm
        pkgs-unstable.koboldcpp
        pkgs-unstable.ollama
        pkgs-unstable.llama-cpp
        pkgs-unstable.stable-diffusion-cpp
        pkgs-unstable.llama-swap
    ];
services.ollama = {
     enable = true;
     host = "0.0.0.0";
     package = pkgs-unstable.ollama-cpu;
     openFirewall = true;
     environmentVariables = {
       OLLAMA_CONTEXT_LENGTH = "65536";
     };
   };
}
