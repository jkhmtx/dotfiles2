# shellcheck shell=bash

list=(
  gh pr list
  --json 'title,url'
  --author @me
  --search '-is:draft'
)

if test "${#}" = 0; then
  "${list[@]}" | jq --raw-output 'to_entries[] | "\(.key + 1). \(.value.url) `\(.value.title)`"'
else
  {
    for arg in "${@}"; do
      "${list[@]}" --repo "${arg}"
    done
  } | jq --raw-output --slurp 'flatten | to_entries[] | "\(.key + 1). \(.value.url) `\(.value.title)`"'
fi
