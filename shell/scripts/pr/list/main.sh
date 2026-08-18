# shellcheck shell=bash

repos=("$@")

if test "${#repos[@]}" -eq 0; then
  repos=("$(gh repo view --json nameWithOwner -q '.nameWithOwner')")
fi

all='[]'
for repo in "${repos[@]}"; do
  chunk=$(gh pr list \
    --repo "${repo}" \
    --author "@me" \
    --state open \
    --limit 100 \
    --search '-is:draft' \
    --json 'title,url,reviewDecision')
  all=$(printf '%s\n%s' "${all}" "${chunk}" | jq -s '.[0] + .[1]')
done

echo "${all}" | jq --raw-output '
  [.[] | select(.reviewDecision != "APPROVED")] |
  to_entries[] |
  "\(.key + 1). `\(.value.title)` \(.value.url)"
'
