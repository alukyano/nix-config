# Run with `nix-shell cuda-shell.nix`
{ pkgs ? import <nixpkgs> {
        config.allowUnfree = true;
        config.cudaSupport = true;
    } }:
pkgs.mkShell {
   name = "cuda-env-shell";
   buildInputs = with pkgs; [
     git
     gitRepo
     gnupg
     autoconf
     curl
     procps
     gnumake
     util-linux
     m4
     gperf
     gperftools
     unzip
     #cudatoolkit
     #opencv-python-headless
     mesa
     cudatoolkit.lib
     cudatoolkit.out
     linuxPackages.nvidia_x11
     libGLU
     libGL
     glib
     xorg.libXi
     xorg.libXmu
     freeglut
     xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
     ncurses5 stdenv.cc binutils
     python310Packages.torch-bin
     python310Packages.triton-bin
     python310Packages.torchvision-bin
     python310Packages.torchaudio-bin
     python310Packages.numpy
     python310Packages.pyopengl
   ];
   shellHook = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
      export LD_PRELOAD="${pkgs.gperftools}/lib/libtcmalloc.so"
      export LD_LIBRARY_PATH=/usr/lib/wsl/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:$(nix eval --raw nixpkgs#addDriverRunpath.driverLink)/lib:"/run/opengl-driver/lib:${pkgs.libGL}/lib/:${pkgs.glib.out}/lib:$LD_LIBRARY_PATH"
      export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
      export EXTRA_CCFLAGS="-I/usr/include"
   '';
}
