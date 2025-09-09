#!/usr/bin/env bash
# Check if at least one argument is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <command> [options]"
  echo "Commands:"
  echo "  desktop    msc-xalukyano"
  echo "  wsl        wsl instance with nvidia"
  echo "  vm         macos VM Vmware"
  exit 1
fi

# Switch by the first parameter
case "$1" in
  desktop)
    echo "Linking desktop..."
    cp -f ~/projects/nix-config/machines/desktop.nix ~/projects/nix-config/config/configuration.nix
    cp -f ~/projects/nix-config/machines/desktop-hw.nix ~/projects/nix-config/config/hardware-configuration.nix
    sudo ln -sf ~/projects/nix-config/config/configuration.nix /etc/nixos/configuration.nix
    ;;
  wsl)
    echo "Linking wsl..."
    cp -f ~/projects/nix-config/machines/wsl-nvidia.nix ~/projects/nix-config/config/configuration.nix
    #cp -f ~/projects/nix-config/machines/desktop-hw.nix ~/projects/nix-config/config/hardware-configuration.nix
    sudo ln -sf ~/projects/nix-config/config/configuration.nix /etc/nixos/configuration.nix
    ;;
  vm)
    echo "Linking vm..."
    cp -f ~/projects/nix-config/machines/vm.nix ~/projects/nix-config/config/configuration.nix
    cp -f ~/projects/nix-config/machines/vm-hw.nix ~/projects/nix-config/config/hardware-configuration.nix
    sudo ln -sf ~/projects/nix-config/config/configuration.nix /etc/nixos/configuration.nix
   
    ;;
  *)
    echo "Invalid command: $1"
    echo "Use $0 desktop|wsl|vm"
    exit 1
    ;;
esac


