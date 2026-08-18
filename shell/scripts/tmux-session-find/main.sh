# shellcheck shell=bash

export PATH="${PATH}"

set -euo pipefail

tmux ls -F '#{session_name}:#{pane_current_path}' >/tmp/tmux-sessions.raw

mapfile -t lines </tmp/tmux-sessions.raw

for line in "${lines[@]}"; do
  session="${line%:*}"
  path="${line#*:}"

  echo "${session},${path}"
done >/tmp/tmux-sessions

tmux display-popup \
  -w 80% \
  -h 60% \
  -E "export PATH=${PATH}; \
  fzf \
  --delimiter , \
  --with-nth '[{1}]: {2}' \
  --preview 'git -C {2} log --oneline --color=always --decorate | $(which bat)' \
  --accept-nth 1 \
  </tmp/tmux-sessions |
  xargs tmux switch-client -t"
