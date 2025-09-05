# nix-config - My Personal NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-blue.svg?style=flat)](https://nixos.org/)
[![Nix](https://img.shields.io/badge/Nix-green.svg?style=flat)](https://nixos.org/nix/)

This repository contains my personal NixOS configuration. It's not recommended  to use it as a starting point for others who want to use nixos.

## Table of Contents

* [About](#about)
* [Configuration Files](#configuration-files)
* [Running the Configuration](#running-the-configuration)
* [Contributing](#contributing)
* [License](#license)

## About

This configuration is based on NixOS version 25.05.

*   [List key aspects of your config, e.g., User environment, Network setup, Shell configuration, etc.]
*   [Example:  A custom shell environment with aliases and prompt.]
*   [Example:  Network configuration using DHCP and static IP.]
*   [Example:  Installation of essential development tools (e.g., Python, Node.js).]

**Note:** This configuration is for a single user and assumes my Desktop.

## Configuration Files

The core configuration files are located in the `configuration.nix` directory.

*   `configuration.nix`: This is the primary NixOS configuration file.


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
    or, if you're not using flakes:
    ```bash
    sudo nixos-rebuild boot
    ```
    (The `switch` command applies the current configuration.  `boot` applies the configuration to the bootloader, which is less common for experimentation).


## Contributing

Because this is personal stuff, I don't need any contributions to this repository!

## License

This repository is licensed under the Ceative Commons License

