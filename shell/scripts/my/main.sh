#!/usr/bin/env bash

set -euo pipefail

export HOME="${HOME}"

dotfiles_dir="$(find-dotfiles-dir)"

case "${1:-}" in
dotfiles | home)
  shift
  case "${1:-}" in
  edit | e)
    nvim "${dotfiles_dir}"
    ;;
  s | switch)
    shift

    case "${1:-}" in
    nixos | work)
      config="${1}"
      shift
      ;;
    *)
      echo "Must specify one of: [nixos|work]"
      ;;
    esac

    home-manager switch --flake "${dotfiles_dir}#${config}" "${@}"

    record-home-manager-flake-metadata "${dotfiles_dir}"
    ;;
  *)
    echo "Must specify one of: [edit|e|switch|s]"
    exit 1
    ;;
  esac
  ;;
machine)
  shift
  case "${1:-}" in
  edit | e)
    nvim "${dotfiles_dir}/nixos"
    ;;
  rebuild)
    shift
    NIXOS_CONFIG="${dotfiles_dir}/nixos" sudo nixos-rebuild "${@}"
    ;;
  *)
    echo "Must specify one of: [edit|e|rebuild]"
    exit 1
    ;;
  esac
  ;;
gc)
  # With thanks to kamadorueda

  # https://github.com/kamadorueda/machine/blob/b2350895cdbc9d063de59f13cd83ccb3f89e8f1a/gc-generations#L1
  nix profile wipe-history \
    --profile /nix/var/nix/profiles/system \
    --older-than 28d

  # https://github.com/kamadorueda/machine/blob/b2350895cdbc9d063de59f13cd83ccb3f89e8f1a/gc-store#L1
  nix profile wipe-history
  nix store gc
  nix store optimise
  ;;

*)
  echo "Must specify one of [dotfiles|gc|home|machine]"
  exit 1
  ;;
esac
