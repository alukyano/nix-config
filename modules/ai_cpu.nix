{pkgs, pkgs-unstable, ...}: {
    environment.systemPackages = [
        pkgs-unstable.openai-whisper
        pkgs-unstable.lmstudio
        pkgs-unstable.vllm
        pkgs-unstable.koboldcpp
        pkgs-unstable.ollama-cpu
    ];
services.ollama = {
     enable = true;
     host = "0.0.0.0:11434";
     openFirewall = true;
     environmentVariables = {
       OLLAMA_CONTEXT_LENGTH = 65536;
     };
   };
}
