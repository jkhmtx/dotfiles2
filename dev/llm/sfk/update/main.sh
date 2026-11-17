#!/usr/bin/env bash

set -euo pipefail

export DOTFILES_DIR="${DOTFILES_DIR}"

unset "${!OTEL_@}"

cd "${DOTFILES_DIR}"/dev/llm/sfk

tag="$(curl -fsSL https://api.github.com/repos/starfolkai/cli/releases/latest | jq -r .tag_name)"
version="${tag#v}"
url="https://github.com/starfolkai/cli/releases/download/${tag}/sfk-darwin-aarch64.tar.gz"
hash="$(nix store prefetch-file --json "${url}" | jq -r .hash)"

jq -n --arg version "${version}" --arg hash "${hash}" '{$version, $hash}' >release.json

echo "sfk ${version}"
