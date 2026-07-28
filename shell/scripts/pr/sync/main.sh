# shellcheck shell=bash

if test "$(git rev-list --count origin/main..HEAD)" -gt 1; then
  echo
  echo "Branch has more than one commit!" >&2
  echo "Exiting"
  echo

  exit 1
fi

title="$(git show -s --format=%s | head -n1)"
body="$(git show -s --format=%b)"

gh pr edit --title "${title}" --body "${body}"
