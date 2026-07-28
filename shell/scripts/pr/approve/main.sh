# shellcheck shell=bash

while read -r line; do
  url="$(echo "${line}" | awk '{
    if (match($0, /github\.com\/[^\/]+\/[^\/]+\/pull\/[0-9]+/)) {
      url = substr($0, RSTART, RLENGTH)
      print url
    }
  }')"

  if test -z "${url}"; then
    continue
  fi

  url="https://${url%https://*}"

  gh pr review "${url}" --approve
done
