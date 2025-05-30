#!/usr/bin/env bash

set -euo pipefail

export HOME="${HOME}"

cd "${HOME}"

FLAKE_INFO=home-manager-flake-info

i=0
for i in 0 1 2; do
  HOME_MANAGER_DIR="$(find . -mindepth "${i}" -maxdepth "${i}" -name "${FLAKE_INFO}" -exec dirname '{}' ';' 2>/dev/null || true)"

  if test -n "${HOME_MANAGER_DIR:-}"; then
    break
  fi
done

case "${1:-}" in
edit | e)
  nvim "${HOME_MANAGER_DIR}"
  ;;
s)
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

  home-manager switch --flake "${HOME_MANAGER_DIR}#${config}" "${@}"

  nix flake metadata "${HOME_MANAGER_DIR}" --json | jq '.locks' >"${HOME_MANAGER_DIR}"/"${FLAKE_INFO}"
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
  home-manager --flake "${HOME_MANAGER_DIR}" "${@}"
  ;;
esac
