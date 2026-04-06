#!/usr/bin/env bash

set -euo pipefail

sessions=/tmp/tmux-sessions

while read -r line; do
  session="$(cut -d':' -f1 <<<"${line}")"
  path="$(cut -d':' -f2 <<<"${line}")"
  branch="$(git -C "${path}" rev-parse --abbrev-ref HEAD || echo "no git")"

  str="${session}: "
  if test -n "${branch:-}"; then
    str+="[${branch}] "
  fi

  str+="${path}"

  echo "${str}"

done \
  <<<"$(tmux ls -F '#{session_name}:#{pane_current_path}')" |
  sort \
    >"${sessions}"

tmux display-popup -E 'fzf --tac <'"${sessions}"' |
  cut -d':' -f1 |
  xargs tmux switch-client -t'
