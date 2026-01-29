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

# git clone https://github.com/Comfy-Org/ComfyUI.git
# nix-shell python-pip.nix
# ln -s /home/alukyano/temp/models /home/alukyano/temp/stable-diffusion-webui-forge/models/Stable-diffusion
# python3 -m venv venv
# python -V
# source venv/bin/activate
# ./venv/bin/pip install torch torchvision torchaudio
# ./venv/bin/pip install -r requirements.txt
# ./venv/bin/pip install -r manager_requirements.txt
# ./venv/bin/pip install --upgrade pip
# python main.py --enable-manager --cpu
