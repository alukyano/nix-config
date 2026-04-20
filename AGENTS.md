# AGENTS.md - NixOS Configuration Project Guidelines

## Project Overview

This is a personal NixOS/Home Manager configuration repository using flakes, managing 5 machines (buldozer, msc-xalukyano, sputnik, saturn, moon) across laptops and desktops. It is **not a library or CLI tool** -- it is a declarative infrastructure configuration. There are no unit tests, CI pipelines, or build scripts in the traditional sense.

## Build Commands

### Build a specific host configuration
```bash
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
```
Replace `<host>` with one of: `buldozer`, `msc-xalukyano`, `sputnik`, `saturn`, `moon`.

### Dry-run / evaluate only
```bash
nix flake check
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel
```

### Apply configuration (on target machine)
```bash
sudo nixos-rebuild switch --flake .#<host>
sudo nixos-rebuild test --flake .#<host>
sudo nixos-rebuild boot --flake .#<host>
```

### Check for formatting errors
```bash
alejandra --check .
deadnix --recurse .
statix check
```

### Format the entire codebase
```bash
alejandra .
```

### Build a dev shell or FHS environment
```bash
nix build .#fhs   # Generic FHS shell
nix build .#fhs-dotnet   # .NET FHS shell
nix build .#comfy-cuda   # ComfyUI CUDA dev shell
```

### Sourcing the environment
```bash
nix develop .#<flake-output>
```

## Code Style Guidelines

### File Naming
- All `.nix` files use **kebab-case** (e.g., `nvidia-prime-intel.nix`, `ai_cuda.nix`)
- Directory entry-point files are named `default.nix`
- Non-Nix config files retain their native naming conventions

### Indentation and Formatting
- **2-space indentation**, no tabs
- Opening brace `{` on the same line as the function arguments (point-free style)
- Use `alejandra` to format -- it is the project's formatter
- Run `alejandra --check .` before making changes to catch formatting issues
- Run `alejandra .` to auto-format

### Module Argument Destructuring
Two acceptable patterns:

**Inline (for short lists):**
```nix
{pkgs, ...}: {
  ...
}
```

**Multi-line (for longer lists, with trailing commas):**
```nix
{
  pkgs,
  lib,
  username,
  ...
}: {
  ...
}
```

Always include `...` to accept extra arguments. Place `...` at the end of the argument list.

### Import Patterns
- Host modules use relative paths from the host directory: `../../modules/common.nix`
- Home Manager modules import directories directly (not `default.nix`): `../../home/programs`
- Directory-level modules use `imports = [ ./foo.nix ./bar.nix ];`
- Hardware configuration is always the first import in a host's `imports` list

### Common Patterns
- Use `lib.mkDefault`, `lib.mkForce`, `lib.optionals`, `lib.elem` from the `lib` argument
- Read other config values via `config.<setting>` (e.g., `config.boot.kernelPackages`)
- Package lists use `with pkgs; [...]` with one package per line
- Commented-out modules use `#../../modules/...` pattern
- Section headers use `# ============================= Section Name =============================`

### State Versions
- Home Manager: `home.stateVersion = "25.05"`
- NixOS system: `system.stateVersion = "25.11"`
- Keep these in sync with the inputs in `flake.nix`

### Overlays
- All overlays use the `self: super: { ... }` pattern
- Package overrides: `super.<pkg>.override { ... }.overrideAttrs (oldAttrs: rec { ... })`
- Custom derivations: `super.stdenv.mkDerivation { ... }`
- Each host can have its own overlay in `overlays/<host>.nix`

### Error Handling
- Use `throw "message"` in Nix for runtime errors (e.g., missing required arguments)
- Use `exit 1` in bash scripts with usage messages

### Linting and Quality Tools
- **alejandra** -- Nix formatter (run before committing)
- **deadnix** -- finds unused let bindings
- **statix** -- linter for Nix code
- These are installed as user packages in `home/shell/common.nix` but **not automated** via pre-commit hooks or CI

### No-Go Rules
- Do not add hardcoded secrets (passwords, keys, tokens) -- use SOPS for secrets
- Do not enable `PermitRootLogin = "yes"` in SSH config
- Do not mix `pkgs` and `pkgs-unstable` without clear separation
- Do not remove the `...` from module argument lists
- Do not commit files matching `*.bak` or `*.tmp`

### Host Configuration Checklist
When adding or modifying a host:
1. Add the host directory under `hosts/<name>/` with `default.nix` and `hardware-configuration.nix`
2. Add the host entry in `flake.nix` following the existing pattern
3. Ensure `pkgs-unstable` is imported with `allowUnfree = true` and any needed overlays
4. Pass `specialArgs` consistently: `{ inherit username desktop pkgs-unstable; }`
5. Import `home-manager.nixosModules.home-manager` with `extraSpecialArgs = inputs // specialArgs`
