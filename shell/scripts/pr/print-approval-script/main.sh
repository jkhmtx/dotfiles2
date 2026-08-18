# shellcheck shell=bash

# Input format: "1. `title` url"
mapfile -t lines </dev/stdin

titles=()
urls=()
for line in "${lines[@]}"; do
  url="${line##* }"
  title=$(echo "${line}" | cut -d'`' -f2)
  titles+=("${title}")
  urls+=("${url}")
done

len="${#titles[@]}"

if [[ "${len}" -eq 0 ]]; then
  exit
fi

for ((i = 0; i < len; i++)); do
  printf "echo '%s'\ngh pr review %s --approve\n" "${titles[$i]}" "${urls[$i]}"
  if [[ $((i + 1)) -lt "${len}" ]]; then
    printf 'echo\n'
  fi
done
