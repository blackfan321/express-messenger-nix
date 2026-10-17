# express-messenger-nix

Nix flake for [eXpress Messenger](https://express.ms/).
Repackages the official Linux and macOS builds.

[![linux](https://img.shields.io/badge/linux-3.75.56-informational)](./_sources/generated.nix)
[![macOS](https://img.shields.io/badge/macOS-3.75.56-informational)](./_sources/generated.nix)
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

### Maintenance
| Command | Description |
|---|---|
| `just update-application` | Runs `nvfetcher` and refreshes README version badges |

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

You also need [nix-direnv](https://github.com/nix-community/nix-direnv). The shell provides `just`, `nvfetcher`, `rg`, `sed`, `wget2`, and the pre-commit packages.

Or enter the shell directly:

```bash
nix develop
```

## Pre-commit

TBD

## Automated Updates

TBD
