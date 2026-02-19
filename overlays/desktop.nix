self: super: {
  llama-cpp =
    (super.llama-cpp.override {
      cudaSupport = true;
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
          hash = "sha256-RztKdBMuY+/3I+QoYybdRrgNp1iAVjDAHGTYxr7exNA=";
        };
        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
          "-DGGML_NATIVE=ON"
        ];
      });

 stable-diffusion-cpp = let
    rev = "636d3cb6ff25d1ffa7267e5f6dac9f2925945606";
    version = "master-${rev}";
  in super.stdenv.mkDerivation {
    pname = "stable-diffusion-cpp";
    inherit version;

    src = super.fetchFromGitHub {
      owner = "leejet";
      repo = "stable-diffusion.cpp";
      rev = rev;
      sha256 = "sha256-PBNRbb8lufHT5mOIhyy6eP+bWQO4N8KjurLgrNuFsH0=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      super.cmake
      super.ninja
      super.git
      super.pkg-config
    ];

    buildInputs = [
      super.openblas
      super.cudaPackages.cudatoolkit
      super.cudaPackages.cuda_cudart
      super.cudaPackages.libcublas
      super.shaderc
      super.glslang
      super.spirv-tools
      super.gtest
    ];

    cmakeFlags = [
      "-DSD_CUDA=ON"
      "-DGGML_OPENBLAS=ON"
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    buildPhase = ''
      runHook preBuild
      mkdir -p $TMPDIR/build
      cd $TMPDIR/build
      cmake $src -DSD_CUDA=ON -DGGML_OPENBLAS=ON -DCMAKE_BUILD_TYPE=Release
      cmake --build . --config Release -j$(nproc)
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp $TMPDIR/build/bin/sd-cli $out/bin/sd-cli
      cp $TMPDIR/build/bin/sd-server $out/bin/sd-server
      chmod +x $out/bin/sd-cli
      chmod +x $out/bin/sd-server
    '';
  };

  llama-swap = super.runCommand "llama-swap" { } ''
    mkdir -p $out/bin
    tar -xzf ${
      super.fetchurl {
        url = "https://github.com/mostlygeek/llama-swap/releases/download/v190/llama-swap_190_linux_amd64.tar.gz";
        hash = "sha256:5807e6278622547fd462afbe97652dea82ea91ddbbd07806ede57ee851bfd0e7";
      }
    } -C $out/bin
    chmod +x $out/bin/llama-swap
  '';

  classic-image-viewer = super.appimageTools.wrapType2 {
    src = super.fetchurl {
      url = "https://github.com/classicimageviewer/ClassicImageViewer/releases/download/v1.4.0/ClassicImageViewer-x86_64.AppImage";
      sha256 = "sha256-M4CSBv22Hvy99vHyuxUV2dnkY4Vz7EjM7FKIVuYwgVQ=";
    };
    pname = "classic-image-viewer";
    version = "1.4.0";
  }; 
}
