{pkgs, pkgs-unstable, ...}: {
    environment.systemPackages = [
        pkgs-unstable.openai-whisper
        pkgs-unstable.lmstudio
        pkgs-unstable.vllm
        pkgs-unstable.koboldcpp
        pkgs-unstable.ollama-cuda
        pkgs-unstable.llama-cpp
        pkgs-unstable.stable-diffusion-cpp
        pkgs-unstable.llama-swap
    ];
    services.ollama = {
     enable = true;
     package = pkgs-unstable.ollama-cuda;
     host = "0.0.0.0";
     openFirewall = true;
     environmentVariables = {
       OLLAMA_CONTEXT_LENGTH = "131072";
     };
   };
}
