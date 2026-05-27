self: super: {
  llama-swap = super.runCommand "llama-swap" { } ''
    mkdir -p $out/bin
    tar -xzf ${
      super.fetchurl {
        url = "https://github.com/mostlygeek/llama-swap/releases/download/v211/llama-swap_211_linux_amd64.tar.gz";
        hash = "sha256-/2KqcCz2axJlRvpjwOvKbQ1rzkp4H1ys+DTi583bRGU=";
      }
    } -C $out/bin
    chmod +x $out/bin/llama-swap
  '';
}