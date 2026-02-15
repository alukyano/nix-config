self: super: {
  ollama = super.ollama.overrideAttrs (oldAttrs: rec {
    version = "0.16.1";
    src = super.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "v${version}";
      hash = "sha256-II9ffgkMj2yx7Sek5PuAgRnUIS1Kf1UeK71+DwAgBRE=";
    };
    vendorHash = "sha256-rKRRcwmon/3K2bN7iQaMap5yNYKMCZ7P0M1C2hv4IlQ=";
  });

  llama-cpp =
    (super.llama-cpp.override {
      cudaSupport = false;
      rocmSupport = false;
      metalSupport = false;
      blasSupport = true;
    }).overrideAttrs
      (oldAttrs: rec {
        version = "8058";
        src = super.fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          tag = "b${version}";
          hash = "sha256-R6qV+0z0Vgl+7JGwC6a+jc+Wv9uIedoRbw9NzRDnjYM=";
        };
        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
          "-DGGML_NATIVE=ON"
        ];
      });
}
