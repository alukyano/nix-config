self: super: {
  llama-swap = super.runCommand "llama-swap" { } ''
    mkdir -p $out/bin
    tar -xzf ${
      super.fetchurl {
        url = "https://github.com/mostlygeek/llama-swap/releases/download/v244/llama-swap_244_linux_amd64.tar.gz";
        hash = "sha256-0qUshAc1fKRjHduXZMjEkoAED9T59OEw8mbS0NNTuW8=";
      }
    } -C $out/bin
    chmod +x $out/bin/llama-swap
  '';
}