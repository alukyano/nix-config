self: super: {
  llama-cpp =
    (super.llama-cpp.override {
      cudaSupport = true;
      rocmSupport = false;
      metalSupport = false;
      blasSupport = true;
    }).overrideAttrs
      (oldAttrs: rec {
        pname = "llama-cpp";
        version = "8984";
        src = super.fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          tag = "b${version}";
          #hash = "sha256-kU3cxkU6OfcSexH1k51Kcp+dLctQd/Frelbn6GCn8Us="; 
          #hash = "sha256-DxgUDVr+kwtW55C4b89Pl+j3u2ILmACcQOvOBjKWAKQ=";  
          hash = "sha256-yppqvwM5+4C0dPOFuh4OGGAxLDjzGdoy+c56vj8YXAU=";
          leaveDotGit = true;
          postFetch = ''
            git -C "$out" rev-parse --short HEAD > $out/COMMIT
            find "$out" -name .git -print0 | xargs -0 rm -rf
          '';
        };
        patches = [ ];
        #vendorHash = "sha256-mQXFTppDI+KgjpZGU40uNOBGNOuMFKXSj3Qld8lTze4=";
        npmRoot = "tools/server/webui";
        npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";
        #npmDepsHash = lib.fakeHash;

        npmDeps = super.fetchNpmDeps {
          name = "${pname}-${version}-npm-deps";
          inherit src patches;
          preBuild = ''
            pushd ${npmRoot}
          '';
          hash = npmDepsHash;
        };
        
          #prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
        prePatch = ''
          touch tools/server/public/index.html.gz
        '';

        preConfigure = ''
          pushd ${npmRoot}
          npm run build
          popd
        '';

        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
          "-DGGML_NATIVE=ON"
          "-DGGML_CUDA_FA_ALL_QUANTS=ON"
        ];
      });

 stable-diffusion-cpp = let
    rev = "593-3d6064b";
    version = "master-${rev}";
  in super.stdenv.mkDerivation {
    pname = "stable-diffusion-cpp";
    inherit version;

    src = super.fetchFromGitHub {
      owner = "leejet";
      repo = "stable-diffusion.cpp";
      tag = version;
      sha256 = "sha256-ExriJzuVfU+ubLaj9sJK/yrW/3RWAjZ0RK4kgmsDY9g=";
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
      "-DGGML_CUDA_FA_ALL_QUANTS=ON"
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
        url = "https://github.com/mostlygeek/llama-swap/releases/download/v209/llama-swap_209_linux_amd64.tar.gz";
        hash = "sha256-DD/+YvT19nde+SvVLRuU4uJLLYQiD3AYRhESa+5OLRo=";
      }
    } -C $out/bin
    chmod +x $out/bin/llama-swap
  '';

  classic-image-viewer = super.appimageTools.wrapType2 {
    src = super.fetchurl {
      url = "https://github.com/classicimageviewer/ClassicImageViewer/releases/download/v1.5.0/ClassicImageViewer-x86_64.AppImage";
      sha256 = "sha256-SgdsIcRu05mJA/bchyIPJ+bZgga4cp4KI4VaqJoRrpE=";
    };
    pname = "classic-image-viewer";
    version = "1.5.0";
  }; 

}
