self: super: {
  llama-cpp =
    (super.llama-cpp.override {
      cudaSupport = false;
      rocmSupport = false;
      metalSupport = false;
      blasSupport = true;
    }).overrideAttrs
      (oldAttrs: rec {
        pname = "llama-cpp";
        version = "9297";
        src = super.fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          tag = "b${version}"; 
          hash = "sha256-7xVKImSbjNPYgGhMLv8nNfjZ1okYw6OAOiPtY2JnSYE=";
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

        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
          "-DGGML_NATIVE=ON"
          "-DLLAMA_BUILD_WEBUI=OFF"
          "-DGGML_AVX512=ON"
          "-DGGML_AVX512_VBMI=ON"
          "-DGGML_AVX512_VNNI=ON"
          "-DGGML_LTO=ON"
          "-DGGML_OPENMP=ON"
          "-DBUILD_SHARED_LIBS=OFF"
        ];
      });
}