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
        version = "8882";
        src = super.fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          tag = "b${version}";
          #hash = "sha256-kU3cxkU6OfcSexH1k51Kcp+dLctQd/Frelbn6GCn8Us="; 
          #hash = "sha256-DxgUDVr+kwtW55C4b89Pl+j3u2ILmACcQOvOBjKWAKQ=";  
          hash = "sha256-K4Bh//yOmMaRiz8DU/Wn/2VQhV+T3AfmU0o8ftW9U7k=";
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
    rev = "585-44cca3d";
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
        url = "https://github.com/mostlygeek/llama-swap/releases/download/v204/llama-swap_204_linux_amd64.tar.gz";
        hash = "sha256-LyXfxfUeM5+BNhZIyhYWsOeTig7TnVg6Twb26Vs1xR8=";
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

  vm-curator = super.appimageTools.wrapType2 {
    src = super.fetchurl {
      url = "https://github.com/mroboff/vm-curator/releases/download/v0.4.7/vm-curator-v0.4.7-x86_64.AppImage";
      sha256 = "sha256-WD4afUZvKsLETXDiQ3dUkzoa7kxQpGANE560MP5uENA=";
    };
    pname = "vm-curator";
    version = "0.4.7";
  };

}
