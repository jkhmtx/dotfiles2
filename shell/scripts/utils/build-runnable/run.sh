#!/usr/bin/env bash

set -Eeuo pipefail

export DRV="${DRV}"
export REPO_PATH="${REPO_PATH}"
export SYSTEM="${SYSTEM}"

nix run --no-warn-dirty "${REPO_PATH}"#.scripts."${SYSTEM}".default."${DRV}" -- "${@}"
