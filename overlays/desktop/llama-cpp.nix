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
        version = "9279";
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
        patches = [ ];
        #vendorHash = "sha256-mQXFTppDI+KgjpZGU40uNOBGNOuMFKXSj3Qld8lTze4=";
        #npmDepsHash = "sha256-k62LIbyY2DXvs7XXbX0lNPiYxuYzeJUyQtS4eA+68f8=";
        #npmDepsHash = lib.fakeHash;

        npmRoot = "tools/ui";
        npmDepsHash = "sha256-WaEePrEZ7O/7deP2KJhe0AwiSKYA8HOqETmMHUkmBe0=";
        npmDeps = super.fetchNpmDeps {
          name = "${pname}-${version}-npm-deps";
          inherit (oldAttrs) src patches;
          preBuild = ''
            pushd ${npmRoot}
          '';
          hash = npmDepsHash;
        };
    
        preConfigure = ''
          mkdir -p build/tools/ui/dist
          mkdir -p build/tools/server/webui/dist
          mkdir -p tools/server/webui/dist
          ${super.lib.concatStrings (
            super.lib.mapAttrsToList (name: drv: ''
              cp ${drv} build/tools/ui/dist/${name}
              // cp ${drv} build/tools/server/webui/dist/${name}
              // cp ${drv} tools/server/webui/dist/${name}
            '') 
          )}
          ${oldAttrs.preConfigure or ""}
        '';

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

        # preConfigure = ''
        #   pushd ${npmRoot}
        #   npm run build
        #   popd
        # '';

        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
          "-DGGML_NATIVE=ON"
          "-DGGML_CUDA_FA_ALL_QUANTS=ON"
        ];
      });
}