# express-messenger-nix

Nix flake for [eXpress Messenger](https://express.ms/).
Repackages the official Linux and macOS builds.

[![linux](https://img.shields.io/badge/linux-3.75.56-informational)](./_sources/generated.nix)
[![macOS](https://img.shields.io/badge/macOS-3.75.56-informational)](./_sources/generated.nix)
[![CI](https://img.shields.io/github/actions/workflow/status/blackfan321/express-messenger-nix/auto-updates.yml?label=CI)](https://github.com/blackfan321/express-messenger-nix/actions/workflows/auto-updates.yml)

## Quick Start

**Try without installing:**
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

## Devshell

Allow [direnv](https://direnv.net/) to activate the flake devshell:

```bash
direnv allow
```

You'll also likely need [nix-direnv](https://github.com/nix-community/nix-direnv). The shell provides `just`, `jq`, `nvfetcher`, `sed`, and the pre-commit packages.

Or enter the shell directly:

```bash
nix develop
```

## Just

[just](https://github.com/casey/just) is a command runner (like `make`, but simpler). Included in the devshell.

| Command | Description |
|---|---|
| [`just update-application`](justfile#L34) | Runs `nvfetcher` and refreshes README version badges |
| [`just update-sources`](justfile#L18) | Runs `nvfetcher` |
| [`just update-badges`](justfile#L23) | Refreshes README version badges from [`_sources/generated.json`](_sources/generated.json) |

## Pre-commit

- [nixfmt](https://github.com/NixOS/nixfmt)
- [deadnix](https://github.com/astro/deadnix)
- [statix](https://github.com/nerdypepper/statix)

Pre-commit hooks are installed automatically when you enter the devshell via [git-hooks.nix](https://github.com/cachix/git-hooks.nix) / [prek](https://github.com/j178/prek).

## Upstream

**Version manifests:**
- Linux: [`latest-linux.yml`](https://updates.express.ms/desktop/latest-linux.yml)
- macOS: [`latest-mac.yml`](https://updates.express.ms/desktop/latest-mac.yml)

**Source artifacts:**
- Linux: `https://updates.express.ms/desktop/eXpress-{version}.AppImage`
- macOS: `https://updates.express.ms/desktop/eXpress-{version}-arm64.dmg`

**Release history:** [eXpress Releases](https://express.ms/en/releases/)

Versions and source hashes are managed with [nvfetcher](https://github.com/berberman/nvfetcher), which generates Nix expressions to [`_sources/generated.nix`](_sources/generated.nix). Source metadata is stored in [`_sources/generated.json`](_sources/generated.json).


## Automated Updates

### [`auto-updates.yml`](.github/workflows/auto-updates.yml)

**Schedule:** daily at 06:00 UTC

**What it does:**
- Updates sources using `nvfetcher`
- Refreshes README version badges
- Opens a PR on `chore/update-express` when versions change

Example PR title / commit message:

```
chore: update eXpress Messenger (3.74.36 → 3.75.56)
```

PR body is the `nvfetcher` changelog.

### [`release.yml`](.github/workflows/release.yml)

**Trigger:** push to `main` when `_sources/generated.json` changes

**What it does:**
- Creates a GitHub Release `X.Y.Z`

Example release:

- **Tag:** `3.75.56`
- **Name:** `3.75.56`
- **Notes:** `eXpress Messenger 3.75.56`
