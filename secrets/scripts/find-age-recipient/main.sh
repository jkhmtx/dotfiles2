# shellcheck shell=bash

eval "$(op signin)"

SSH_KEY_PATH="${HOME}/.ssh/id_ed25519"
op read "op://private/nixos/private key" >"${SSH_KEY_PATH}"
op read "op://private/nixos/public key" >"${SSH_KEY_PATH}.pub"

SOPS_AGE_DIR="${XDG_CONFIG_HOME:-${HOME}}/.config/sops/age"
mkdir -p "${SOPS_AGE_DIR}"
ssh-to-age -private-key -i "${SSH_KEY_PATH}" -o "${SOPS_AGE_DIR}/keys.txt"

>&2 echo "Age recipient:"
ssh-to-age -i "${SSH_KEY_PATH}.pub"
