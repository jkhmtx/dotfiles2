# shellcheck shell=bash

cd "$(git rev-parse --show-toplevel)/secrets" || exit 1

sops secrets.yaml
