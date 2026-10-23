# shellcheck shell=bash

export PWD="${PWD}"
export TMUX="${TMUX:-}"

set -euo pipefail

if ! test -n "${TMUX:-}"; then
  echo "ERROR: Not in a tmux session" >&2
  exit 1
fi

directory="${2:-"${PWD}"}"

tmux_new_window_args=(
  -c "${directory}"
)

mkdir -p "${directory}"

if test -v 1 && test "${1}" != "--"; then
  tmux_new_window_args+=(
    -n "${1}"
  )
fi

tmux new-window "${tmux_new_window_args[@]}"
