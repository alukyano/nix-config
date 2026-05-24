self: super: {
 stable-diffusion-cpp = let
    rev = "647-72e512a";
    version = "master-${rev}";
  in super.stdenv.mkDerivation {
    pname = "stable-diffusion-cpp";
    inherit version;

    src = super.fetchFromGitHub {
      owner = "leejet";
      repo = "stable-diffusion.cpp";
      tag = version;
      #rev = rev;
      sha256 = "sha256-vJ9pudTS8cYDUmgnuMhOg3l3jtvtn4XgtqEFWfgIodY=";
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
      super.vulkan-headers
      super.vulkan-loader
      super.vulkan-validation-layers
      super.shaderc
      super.glslang
      super.spirv-tools
      super.gtest
    ];

    cmakeFlags = [
      "-DGGML_OPENBLAS=ON"
      "-DSD_VULKAN=ON"
      "-DGGML_AVX512=ON"
      "-DGGML_AVX512_VBMI=ON"
      "-DGGML_AVX512_VNNI=ON"
      "-DGGML_LTO=ON"
      "-DGGML_OPENMP=ON"
      "-DBUILD_SHARED_LIBS=OFF"
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
}