self: super: {
  # Add the nixos-rocm overlay
  rocm = import (fetchTarball "https://github.com/nixos-rocm/nixos-rocm/archive/master.tar.gz") {
    # You can specify the desired ROCm version and GPU targets here
    # For example:
    rocmTargets = [ "gfx1103" ];
  };
}
