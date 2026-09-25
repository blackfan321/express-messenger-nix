# express-messenger-nix

Nix flake for [eXpress Messenger](https://express.ms/).
Repackages the official Linux and macOS builds.

[![linux](https://img.shields.io/badge/linux-3.73.51-informational)](./express.nix)
[![macOS](https://img.shields.io/badge/macOS-3.73.51-informational)](./express.nix)
[![CI](https://img.shields.io/github/actions/workflow/status/blackfan321/express-messenger-nix/update.yml?label=CI)](https://github.com/blackfan321/express-messenger-nix/actions/workflows/update.yml)

## Quick Start

**Try it without installing:**
```bash
nix run github:blackfan321/express-messenger-nix
```

**Install into your profile:**
```bash
nix profile install github:blackfan321/express-messenger-nix
```

## Installation

### NixOS Flake

```nix
{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    express-messenger = {
      url = "github:blackfan321/express-messenger-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, express-messenger, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      modules = [{ pkgs, ... }: {
        environment.systemPackages = [
          express-messenger.packages.${pkgs.stdenv.hostPlatform.system}.express
        ];
      }];
    };
  };
}
```

### Home Manager

```nix
{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.express-messenger.packages.${pkgs.stdenv.hostPlatform.system}.express
  ];
}
```

## Platforms

- `x86_64-linux`
- `aarch64-darwin`

## Just

### Linux
| Command | Description |
|---|---|
| `just get-latest-appimage-version` | Prints the latest AppImage version |
| `just pull-appimage <version>` | Downloads an AppImage for a given version; prints its sha256 |
| `just pull-latest-appimage` | Downloads the latest AppImage; prints its sha256 |

### macOS
| Command | Description |
|---|---|
| `just get-latest-dmg-version` | Prints the latest Apple Silicon disk image version |
| `just pull-dmg <version>` | Downloads a disk image for a given version; prints its sha256 |
| `just pull-latest-dmg` | Downloads the latest disk image; prints its sha256 |

### Maintenance
| Command | Description |
|---|---|
| `just update-application` | Updates the package to the latest release for each platform |
| `just cleanup` | Removes downloaded application artifacts from the repo root |

### Pre-commit (prek)
| Command | Description |
|---|---|
| `just prek-install` | Installs the pre-commit hook |
| `just prek-uninstall` | Removes the pre-commit hook |
| `just prek-run` | Runs all checks against all repo files |

## Devshell

Allow [direnv](https://direnv.net/) to activate flake devshell:

```bash
direnv allow
```

You also need [nix-direnv](https://github.com/nix-community/nix-direnv). The shell provides `just`, `rg`, `sed`, `wget2`, and the pre-commit packages.

Or enter the shell directly:

```bash
nix develop
```

## Pre-commit

TBD

## Automated Updates

TBD
