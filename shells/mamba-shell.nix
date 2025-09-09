{ pkgs ? import <nixpkgs> {} }:

pkgs.buildFHSEnv {
  name = "micromamba-env";
  targetPkgs = ps: [ ps.micromamba ps.bash ps.gcc ps.fontconfig ]; # add libs if needed
  profile = ''
        set -e
        eval "$(micromamba shell hook --shell=posix)"
        export MAMBA_ROOT_PREFIX=${builtins.getEnv "PWD"}/.mamba
        micromamba create -q -n env1 python=3.10
        micromamba activate my-env1
        micromamba install --yes -f conda-requirements.txt -c conda-forge
        set +e
  '';
}
