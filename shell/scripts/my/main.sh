#!/usr/bin/env bash

set -euo pipefail

export HOME="${HOME}"
export DOTFILES_DIR="${DOTFILES_DIR}"

case "${1:-}" in
dotfiles | home)
  shift
  case "${1:-}" in
  edit | e)
    nvim "${DOTFILES_DIR}"
    ;;
  s | switch)
    shift
    home-manager switch --flake "${DOTFILES_DIR}#$(hostname)" "${@}"
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
    nvim "${DOTFILES_DIR}/nixos"
    ;;
  switch)
    shift

    sudo nixos-rebuild switch --flake "${DOTFILES_DIR}"
    ;;
  rebuild)
    shift

    sudo nixos-rebuild "${@}" --flake "${DOTFILES_DIR}"
    ;;
  *)
    echo "Must specify one of: [edit|e|rebuild]"
    exit 1
    ;;
  esac
  ;;
gc)
  shift
  days="${1:?Specify number of days}"

  # With thanks to kamadorueda
  # https://github.com/kamadorueda/machine/blob/b2350895cdbc9d063de59f13cd83ccb3f89e8f1a/gc-generations#L1
  nix profile wipe-history \
    --profile /nix/var/nix/profiles/system \
    --older-than "${days}"d

  # https://github.com/kamadorueda/machine/blob/b2350895cdbc9d063de59f13cd83ccb3f89e8f1a/gc-store#L1
  nix profile wipe-history --older-than "${days}"d
  nix store gc
  nix store optimise

  home-manager expire-generations "-${days} days"
  ;;

*)
  echo "Must specify one of [dotfiles|gc|home|machine]"
  exit 1
  ;;
esac
