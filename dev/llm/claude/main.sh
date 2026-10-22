#!/usr/bin/env bash

set -euo pipefail

export NODE_MODULES="${NODE_MODULES}"
export CLAUDE_SETTINGS="${CLAUDE_SETTINGS}"

exec node "${NODE_MODULES}/node_modules/@anthropic-ai/claude-code/cli-wrapper.cjs" \
  --allow-dangerously-skip-permissions \
  --settings "${CLAUDE_SETTINGS}" \
  "$@"
