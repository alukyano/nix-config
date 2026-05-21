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
        version = "9264";
        src = super.fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          tag = "b${version}";  
          hash = "sha256-LA4SgE20Dvz1g3degdIx4CYfYhVNEIQM5Q/5rDT/icg=";
          leaveDotGit = true;
          postFetch = ''
            git -C "$out" rev-parse --short HEAD > $out/COMMIT
            find "$out" -name .git -print0 | xargs -0 rm -rf
          '';
        };
        #patches = [ ];
        vendorHash = "sha256-mQXFTppDI+KgjpZGU40uNOBGNOuMFKXSj3Qld8lTze4=";
        #npmRoot = "tools/server/webui";
        #npmDepsHash = "sha256-k62LIbyY2DXvs7XXbX0lNPiYxuYzeJUyQtS4eA+68f8=";
        #npmDepsHash = lib.fakeHash;

        # npmDeps = super.fetchNpmDeps {
        #   name = "${pname}-${version}-npm-deps";
        #   inherit src patches;
        #   preBuild = ''
        #     pushd ${npmRoot}
        #   '';
        #   hash = npmDepsHash;
        # };
        
        #   #prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
        # prePatch = ''
        #   touch tools/server/public/index.html.gz
        # '';

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
}