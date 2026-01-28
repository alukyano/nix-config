# truly works for comfy
{ pkgs ? import <nixpkgs> {
        config.allowUnfree = true;
        config.cudaSupport = true;
    } }:

(pkgs.buildFHSEnv {
  name = "python-pip";
  targetPkgs = pkgs: (with pkgs; [
    python311
    python311Packages.pip
    python311Packages.virtualenv
    cudaPackages.cudatoolkit
  ]);
  runScript = "bash --init-file /etc/profile";
}).env