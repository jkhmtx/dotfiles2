#!/usr/bin/env bash

set -euo pipefail

export HOME="${HOME}"
export FLAKE_INFO="${FLAKE_INFO}"

i=0
for i in 0 1 2; do
  home_manager_dir="$(find "${HOME}" -mindepth "${i}" -maxdepth "${i}" -name "${FLAKE_INFO}" -exec dirname '{}' ';' 2>/dev/null || true)"

  if test -n "${home_manager_dir:-}"; then
    echo "${home_manager_dir}"
    exit
  fi
done

exit 1
