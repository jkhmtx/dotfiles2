#!/usr/bin/env bash

export OH_MY_POSH_CONFIG="${OH_MY_POSH_CONFIG}"
export COMPLETIONS_DIR="${COMPLETIONS_DIR}"

# Prompt theming
eval "$(oh-my-posh init zsh --config "${OH_MY_POSH_CONFIG}")"

# Completions
for completion in "${COMPLETIONS_DIR}"/*; do
  # shellcheck disable=SC1090
  source "${completion}"
done
