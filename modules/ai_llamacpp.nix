{ config, pkgs-unstable, ... }:

{
  nixpkgs.config.packageOverrides = pkgs-unstable: {
    ollama = pkgs-unstable.ollama.overrideAttrs (oldAttrs: rec {
      version = "0.15.6";
      src = pkgs-unstable.fetchFromGitHub {
        owner = "ollama";
        repo = "ollama";
        rev = "v${version}";
        hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
      };
      vendorHash = "sha256-rKRRcwmon/3K2bN7iQaMap5yNYKMCZ7P0M1C2hv4IlQ=";
      postFixup = pkgs-unstable.lib.replaceStrings [
        ''mv "$out/bin/app" "$out/bin/.ollama-app"''
      ] [
        ''if [ -e "$out/bin/app" ]; then
           mv "$out/bin/app" "$out/bin/.ollama-app"
         fi''
      ] oldAttrs.postFixup;
    });

    llama-cpp =
      (pkgs-unstable.llama-cpp.override {
        cudaSupport = false;
        rocmSupport = false;
        metalSupport = false;
        blasSupport = true;
      }).overrideAttrs
        (oldAttrs: rec {
          version = "7974";
          src = pkgs-unstable.fetchFromGitHub {
            owner = "ggml-org";
            repo = "llama.cpp";
            tag = "b${version}";
            hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
            leaveDotGit = true;
            postFetch = ''
              git -C "$out" rev-parse --short HEAD > $out/COMMIT
              find "$out" -name .git -print0 | xargs -0 rm -rf
            '';
          };
          cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
            "-DGGML_NATIVE=ON"
          ];
          preConfigure = ''
            export NIX_ENFORCE_NO_NATIVE=0
            ${oldAttrs.preConfigure or ""}
          '';
        });

    llama-swap = pkgs-unstable.runCommand "llama-swap" { } ''
      mkdir -p $out/bin
      tar -xzf ${
        pkgs-unstable.fetchurl {
          url = "https://github.com/mostlygeek/llama-swap/releases/download/v190/llama-swap_190_linux_amd64.tar.gz";
          hash = "sha256:5807e6278622547fd462afbe97652dea82ea91ddbbd07806ede57ee851bfd0e7";
        }
      } -C $out/bin
      chmod +x $out/bin/llama-swap
    '';
  };
}
