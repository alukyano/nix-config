self: super: {
  # ollama = super.ollama.overrideAttrs (oldAttrs: rec {
  #   version = "0.15.6";
  #   src = super.fetchFromGitHub {
  #     owner = "ollama";
  #     repo = "ollama";
  #     rev = "v${version}";
  #     hash = "sha256-II9ffgkMj2yx7Sek5PuAgRnUIS1Kf1UeK71+DwAgBRE=";
  #   };
  #   # vendorHash = "sha256-OQOx0G4kxToe8soef4vZDhp1RtTnLkiT2tQBXgB3T5E=";
  #   # nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ super.tree-sitter ];
  #   # postPatch = ''
  #   #   # Create symlinks for tree-sitter sources
  #   #   mkdir -p vendor/github.com/tree-sitter/tree-sitter-cpp/src
  #   #   ln -sf ${super.tree-sitter}/include/tree_sitter/*.h vendor/github.com/tree-sitter/tree-sitter-cpp/src/ 2>/dev/null || true
  #   #   ln -sf ${super.tree-sitter}/src/*.c vendor/github.com/tree-sitter/tree-sitter-cpp/src/ 2>/dev/null || true
  #   # '';
  #   # CGO_CFLAGS = "-I${super.tree-sitter}/include -I${super.tree-sitter}/lib";
  #   vendorHash = null;
  #   nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ super.tree-sitter ];
  #   buildInputs = (oldAttrs.buildInputs or []) ++ [ super.tree-sitter ];
  #   CGO_CFLAGS = "-I${super.tree-sitter}/include";
  #   CGO_LDFLAGS = "-L${super.tree-sitter}/lib";
  # });

 llama-cpp =
    (super.llama-cpp.override {
      cudaSupport = true;
      rocmSupport = false;
      metalSupport = false;
      blasSupport = true;
    }).overrideAttrs
      (oldAttrs: rec {
        pname = "llama-cpp";
        version = "9279";
        src = super.fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          tag = "b${version}";
          #hash = "sha256-DxgUDVr+kwtW55C4b89Pl+j3u2ILmACcQOvOBjKWAKQ=";  
          hash = "sha256-QhTboBhXQVFyZLlaqXxP254kMq/9idb1fgSsy6pWlvA=";
          leaveDotGit = true;
          postFetch = ''
            git -C "$out" rev-parse --short HEAD > $out/COMMIT
            find "$out" -name .git -print0 | xargs -0 rm -rf
          '';
        };
       patches = [ ];
        #vendorHash = "sha256-mQXFTppDI+KgjpZGU40uNOBGNOuMFKXSj3Qld8lTze4=";
        #npmRoot = "tools/server/webui";
        npmRoot = "tools/ui";
        npmDepsHash = "sha256-Iyg8FpcTKf2UYHuK7mA3cTAqVaLcQPcS0YCa5Qf01Gc=";
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
        # prePatch = ''
        #   touch tools/server/public/index.html.gz
        # '';

        # preConfigure = ''
        #   mkdir -p build/tools/ui/dist
        #   ${super.lib.concatStrings (
        #     super.lib.mapAttrsToList (name: drv: ''
        #       cp ${drv} build/tools/ui/dist/${name}
        #     '') uiAssets
        #   )}
        #   export NIX_ENFORCE_NO_NATIVE=0
        #   ${oldAttrs.preConfigure or ""}
        # '';

        # preConfigure = ''
        #   pushd ${npmRoot}
        #   npm run build
        #   popd
        # '';

        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [f
          "-DGGML_NATIVE=ON"
          "-DGGML_CUDA_FA_ALL_QUANTS=ON"
          "-DCMAKE_CUDA_ARCHITECTURES=50"
          "-DCMAKE_CUDA_FLAGS=-Wno-deprecated-gpu-targets"
          "-DLLAMA_BUILD_WEBUI=OFF" 
          "-DGGML_CUDA_ENABLE_UNIFIED_MEMORY=ON"
          "-DGGML_CUDA_FA_ALL_VARIANTS=ON"
          "-DBUILD_SHARED_LIBS=OFF"
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
      "-DCMAKE_CUDA_ARCHITECTURES=50"
      "-DGGML_CUDA_FA_ALL_QUANTS=ON"
      "-DCMAKE_CUDA_FLAGS=-Wno-deprecated-gpu-targets"
      "-DGGML_OPENBLAS=ON"
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    buildPhase = ''
      runHook preBuild
      mkdir -p $TMPDIR/build
      cd $TMPDIR/build
      cmake $src -DSD_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=50 -DCMAKE_CUDA_FLAGS="-Wno-deprecated-gpu-targets" -DGGML_OPENBLAS=ON -DCMAKE_BUILD_TYPE=Release
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
        url = "https://github.com/mostlygeek/llama-swap/releases/download/v211/llama-swap_211_linux_amd64.tar.gz";
        hash = "sha256-/2KqcCz2axJlRvpjwOvKbQ1rzkp4H1ys+DTi583bRGU=";
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
