program_name := "express"
sources_file := "_sources/generated.nix"
readme_file := "README.md"
changelog_file := ".nvfetcher-changelog"

set quiet := true
set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

[private]
default:
    @just --choose

[private]
read-version name:
  sed -n '/^  {{name}} = {/,/^  };/ s/^    version = "\([^"]*\)".*/\1/p' "{{sources_file}}"

[private]
update-readme:
  #!/usr/bin/env bash
  set -euo pipefail
  linux="$(just read-version express-linux)"
  darwin="$(just read-version express-darwin)"
  sed -i \
    -e 's|shields.io/badge/linux-[^-]*-|shields.io/badge/linux-'"$linux"'-|' \
    -e 's|shields.io/badge/macOS-[^-]*-|shields.io/badge/macOS-'"$darwin"'-|' \
    "{{readme_file}}"

[group('maintenance')]
update-application:
  #!/usr/bin/env bash
  set -euo pipefail
  nvfetcher -l "{{changelog_file}}"
  just update-readme
  if [[ -s "{{changelog_file}}" ]]; then
    echo -e "Changes:\n" >&2
    cat "{{changelog_file}}" >&2
  fi

[group('prek')]
prek-install:
  nix develop -c prek install

[group('prek')]
prek-uninstall:
  nix develop -c prek uninstall

[group('prek')]
prek-run:
  nix develop -c prek run --all-files
