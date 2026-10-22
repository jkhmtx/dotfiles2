#!/usr/bin/env bash

set -euo pipefail

export DOTFILES_DIR="${DOTFILES_DIR}"

cd "${DOTFILES_DIR}"/dev/llm/claude

rm -f package-lock.json

npm install
