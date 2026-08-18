#!/usr/bin/env bash

export COMPLETIONS_DIR="${COMPLETIONS_DIR}"
export OH_MY_POSH_CONFIG="${OH_MY_POSH_CONFIG}"
export OMP_KEY="${OMP_KEY}"

# Prompt theming
oh_my_posh_cache="${HOME}"/.cache/oh-my-posh/"${OMP_KEY}"

mkdir -p "${oh_my_posh_cache}"
if ! test -f "${oh_my_posh_cache}"/init.zsh; then
  oh-my-posh init zsh --config "${OH_MY_POSH_CONFIG}" >"${oh_my_posh_cache}"/init.zsh
fi

# shellcheck disable=1091
source "${oh_my_posh_cache}"/init.zsh

# Completions
for completion in "${COMPLETIONS_DIR}"/*; do
  # shellcheck disable=SC1090
  source "${completion}"
done

# shellcheck disable=1090
source ~/extra.zshenv >/dev/null 2>&1

export PATH="${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"
