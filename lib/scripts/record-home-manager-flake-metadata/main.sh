#!/usr/bin/env bash

set -euo pipefail

export FLAKE_INFO="${FLAKE_INFO}"

nix flake metadata "${1}" --json | jq 'pick(.description, .path, .locks)' >"${1}"/"${FLAKE_INFO}"

cd "${1}"

git add "${1}"/"${FLAKE_INFO}"
