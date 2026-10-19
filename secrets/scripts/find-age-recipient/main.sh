# shellcheck shell=bash
eval "$(sudo op signin)"

tmp="$(mktemp -d)"

trap cleanup EXIT

cleanup() {
  rm -rf "${tmp}"
}

SSH_DIR="${HOME}/.ssh"

op read "op://private/nixos/private key" >"${tmp}"/pkey
cp "${tmp}"/pkey "${SSH_DIR}"/id_ed25519-age
cp "${tmp}"/pkey "${SSH_DIR}"/id_ed25519

op read "op://private/nixos/public key" >"${tmp}"/pub
cp "${tmp}"/pub "${SSH_DIR}/id_ed25519-age.pub"

SOPS_AGE_DIR="${XDG_CONFIG_HOME:-${HOME}}/.config/sops/age"
mkdir -p "${SOPS_AGE_DIR}"
ssh-to-age -private-key -i "${SSH_DIR}/id_ed25519-age" -o "${SOPS_AGE_DIR}/keys.txt"

>&2 echo "Age recipient:"
ssh-to-age -i "${SSH_DIR}/id_ed25519-age.pub"
