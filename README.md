# nix-config - My Personal NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-blue.svg?style=flat)](https://nixos.org/)
[![Nix](https://img.shields.io/badge/Nix-green.svg?style=flat)](https://nixos.org/nix/)

This repository contains my personal NixOS configuration using flakes. It's not recommended  to use it as a starting point for others who want to use nixos. Of course, you can look on it and reuse any parts in case you found it's useful.

## Table of Contents

* [About](#about)
* [Running the Configuration](#running-the-configuration)
* [Contributing](#contributing)
* [License](#license)

## About

This configuration is based on NixOS version 25.05.

**Note:** This configuration is for a single user and assumes my Desktop only.

**Important:**  Be very careful when applying this configuration to a new system.  Understand what each setting does *before* applying it.

## Running the Configuration

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/alukyano/nix-config
    cd nix-config
    ```

2.  **Apply the Configuration:**
    ```bash
    sudo nixos-rebuild switch --flake .#config
    ```

## Contributing

Because this is almost personal stuff, I don't need any contributions to this repository!

## License

This repository is licensed under the Ceative Commons License

