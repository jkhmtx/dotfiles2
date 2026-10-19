# shellcheck shell=bash

export PWD="${PWD}"
export TMUX="${TMUX:-}"

set -euo pipefail

if ! test -n "${TMUX:-}"; then
  echo "ERROR: Not in a tmux session" >&2
  exit 1
fi

if ! test -v 1; then
  echo "ERROR: Session name is required" >&2
  exit 1
fi

session="${1}"
current_window="$(tmux display-message -p '#{session_name}:#{window_id}')"
placeholder_window="$(tmux new-session -d -s "${session}" -c "${PWD}" -P -F '#{window_id}')"

tmux move-window -s "${current_window}" -t "${session}:"
tmux kill-window -t "${placeholder_window}"
tmux switch-client -t "${session}"
