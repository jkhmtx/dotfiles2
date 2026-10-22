#!/usr/bin/env bash

set -euo pipefail

export NODE_MODULES="${NODE_MODULES}"

exec node "${NODE_MODULES}/node_modules/ccstatusline/dist/ccstatusline.js" "$@"
