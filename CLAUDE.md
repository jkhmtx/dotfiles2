# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Nix flake holding Home Manager configs (and, for the personal machine, a NixOS system config) for two hosts:

- `hosts/nixos.nix` — personal Linux box (`x86_64-linux`, user `jakeh`, repo at `~/projects/dotfiles`), Home Manager + NixOS.
- `hosts/SB-US-B0E2-jhamilton.nix` — work Mac (`aarch64-darwin`, user `jake`, repo at `~/dotfiles2`, pinned to the `nixpkgs-work` input), Home Manager only.

## Commands

The `my` script (`shell/scripts/my/main.sh`) wraps the usual workflows:

- `my home switch` — `home-manager switch --flake <repo>#$(whoami)@$(hostname)` (config name = `<user>@<host file name>`, so the hostname must match).
- `my machine switch` — `sudo nixos-rebuild switch --flake <repo>`; `my machine rebuild <subcmd>` for other `nixos-rebuild` verbs (e.g. `build`, `dry-build`).
- `my gc <days>` — wipe old profile generations and GC the store.

Checking a change without activating it:

- `nix build '.#homeConfigurations."jakeh@nixos".activationPackage'`
- `nix build .#nixosConfigurations.nixos.config.system.build.toplevel`
- `nix run .#scripts.x86_64-linux.default.<name>` — run one shell script, e.g. `pr.list`.

Other:

- `edit-home-secrets` — edit `secrets/secrets.yaml` with sops (age key derived from `~/.ssh/id_ed25519`).
- `claude.update` — regenerate `dev/llm/claude/package-lock.json` (Claude Code is installed from that npm lockfile, not nixpkgs).
- `nix develop` — dev shell with `tofu` and the `.github/terraform` plan/apply scripts (manages GitHub repo settings).

Formatting/linting (as configured in nvim): Nix with `alejandra`, shell with `shfmt` + `shellcheck` (rc at `shell/shellcheckrc`), Lua with `stylua`.

Flakes only see git-tracked files: `git add` new files before building.

## Architecture

**`flake.nix` → `mkConfiguration`.** Every file in `hosts/` is auto-discovered and passed to `mkConfiguration`. A host file declares `nixpkgs`, `system`, `users.<name>` (per-user: `user`, `repoPath`, Home Manager `modules`, `unfree`) and `nixOs` (machine: `modules`, `unfree`; `null` for HM-only hosts). Each user becomes `homeConfigurations."<name>@<host>"`; the machine becomes `nixosConfigurations.<host>`. `devShell` and `scripts` outputs are taken from a named user per system in the flake outputs.

**Machine vs per-user.** NixOS modules get only machine-level `mySpecialArgs` (`rootPath`, `system`, `inputs`, `lib`, `unfree`) — no `user`/`repoPath` — so machine config can't depend on a user. A user's machine-side needs (account, SSH access, auto-login, polkit ownership) live in `nixos/users/<name>.nix`, listed in the host's `nixOs.modules`. Desktop tooling and apps belong in Home Manager modules; `nixos/display` only offers sessions.

**`mySpecialArgs` (Home Manager).** `rootPath`, `repoPath`, `system`, `inputs`, `lib` (this repo's `lib/`, not nixpkgs lib), `user`, `unfree`. Modules read user specifics from here rather than hardcoding.

**Unfree packages.** Each feature that needs unfree packages has an `unfree.nix` returning a list of package names. `unfree.nix` at the root builds `allowUnfreePredicate` from `mySpecialArgs.unfree` — the user's `unfree` list for Home Manager, and `nixOs.unfree` for the NixOS system. New unfree packages must be listed in a feature `unfree.nix` *and* that file referenced in the relevant list.

**Module layout.** Top-level directories are feature modules (`dev/*`, `shell`, `term/*`, `hypr`, `browser`, `audio`, `borg`, `secrets`, …), each a `default.nix` imported via a user's `modules`. `nixos/` is the NixOS system config, rooted at `nixos/configuration.nix`; hardware specifics (e.g. NVIDIA) are in `nixos/hardware/`.

**Shell scripts (`shell/scripts/`).** Each script is a directory with `default.nix` (`pkgs.writeShellApplication` reading `./main.sh`) and `main.sh`. To add one, register it in `shell/scripts/index.nix`; its attr path (e.g. `pr.list`) becomes the command name. `shell/scripts/default.nix` builds a nested attrset plus a `flattened` map, exposed as the flake's `scripts.<system>.default`. `shell/default.nix` installs each script not as the derivation itself but as a thin `build-runnable` wrapper that does `nix run <repoPath>#scripts.<system>.default.<name>` — so script edits take effect without a `home switch`. Scripts referenced directly by modules (e.g. `secrets/scripts/*`, `dev/llm/claude/*`) follow the same `default.nix` + `main.sh` pattern but are added to `home.packages` normally.

**Out-of-store symlinks.** `lib.home-manager.mkSymlinkAttrs` (`lib/home-manager/mk-symlink-attrs.nix`) extends `home.file` entries with `outOfStoreSymlink = true` (and `recursive`), linking to the live file in `repoPath` instead of the store copy so edits apply immediately (used for Hyprland configs). Paths must live under the repo.

**Neovim.** Built with nixCats in `dev/nvim/default.nix`: categories map to LSPs/tools/plugins, Lua config in `dev/nvim/config/lua/my/`. Adding a language means adding its tools under `lspsAndRuntimeDeps`, enabling the category in `packageDefinitions`, and adding `lua/my/lsp/<lang>.lua`.

**Secrets.** sops-nix with `secrets/secrets.yaml`. User secrets are declared in `secrets/secrets.nix` (imported by `secrets/home-manager.nix`); machine secrets (wifi, cloudflared) in `secrets/default.nix` (NixOS).

**Dependencies.** Renovate (`.github/renovate.json`) automerges flake input and lockfile updates.
