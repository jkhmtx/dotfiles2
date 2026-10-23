# shellcheck shell=bash
export SOPS_CONFIG="${SOPS_CONFIG}"
export SOPS_FILE="${SOPS_FILE}"
export PUBLIC_KEY="${PUBLIC_KEY}"

eval "$(op signin)"

umask 077

tmp="$(mktemp -d)"

trap 'rm -rf "${tmp}"' EXIT

SSH_DIR="${HOME}/.ssh"

public_fingerprint() {
  ssh-keygen -lf "${1}" 2>/dev/null | cut -d' ' -f2
}

private_fingerprint() {
  ssh-keygen -yf "${1}" 2>/dev/null | ssh-keygen -lf - 2>/dev/null | cut -d' ' -f2
}

op read "op://private/nixos/public key" >"${tmp}"/pub
op read "op://private/nixos/private key" >"${tmp}"/pkey
sops decrypt --extract '["ssh-private-key"]' "${SOPS_FILE}" >"${tmp}"/sops-key 2>/dev/null || true

expected="$(public_fingerprint "${tmp}"/pub)"
echo "1Password public key: ${expected}"

status=0

check() {
  if [[ "${2}" == "${expected}" ]]; then
    echo "OK       ${1}"
  else
    echo "MISMATCH ${1}: ${2:-unreadable}"
    status=1
  fi
}

check "1Password private key" "$(private_fingerprint "${tmp}"/pkey)"
check "${SSH_DIR}/id_ed25519" "$(private_fingerprint "${SSH_DIR}"/id_ed25519)"
check "id_ed25519.pub in the repo" "$(public_fingerprint "${PUBLIC_KEY}")"
check "sops ssh-private-key, decrypted with ${SSH_DIR}/id_ed25519" "$(private_fingerprint "${tmp}"/sops-key)"

recipient="$(ssh-to-age -i "${tmp}"/pub)"
if grep -q "${recipient}" "${SOPS_CONFIG}"; then
  echo "OK       age recipient ${recipient} in .sops.yaml"
else
  echo "MISMATCH age recipient ${recipient} not in .sops.yaml"
  status=1
fi

exit "${status}"
