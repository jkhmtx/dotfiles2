# shellcheck shell=bash

cd "$(git rev-parse --show-toplevel)/.github/terraform" || exit 1

export GITHUB_TOKEN_FILE="${GITHUB_TOKEN_FILE}"

github_token="$(cat "${GITHUB_TOKEN_FILE}")"
export GITHUB_TOKEN="${github_token}"

tofu init
tofu plan
