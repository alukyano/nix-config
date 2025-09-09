{ config, lib, pkgs, ... }:
{
    # Allow unfree packages
    nixpkgs.config = {
        allowUnfree = true;
        #cudaSupport = true;
      };
    #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "cuda_cccl" "cuda_cudart" "cuda_nvcc" "libcublas" "nvidia-settings" "nvidia-x11" ]; 

    environment.systemPackages = with pkgs; [
        nix-index
        cachix
        binutils
        direnv
        exfat
        nox
        ntfs3g
        patchelf
        pciutils
        wget
        curl
        jq
        mc
        htop
        rsync
        neofetch
        git
        gdal
        gperftools
        neovim
        imagemagick
    # Dev
        go
        llvmPackages_latest.bintools
        llvmPackages_latest.clang
        llvmPackages_latest.lldb
        llvmPackages_latest.stdenv
        maven
        nil
        ninja
        nodejs
        protobuf
        gcc
        libgcc
        clang-tools
        cmake
        jre_minimal
        jdk
        wine
        winetricks
        uv
        micromamba
        #python310.withPackages
    # Archives
        unrar
        unzip
        atool
        zip
        p7zip  
    # media
        ffmpeg
        yt-dlp    
   ];
}