#!/usr/bin/env bash

set -euo pipefail

export CLIENT_ID_FILE="${CLIENT_ID_FILE}"
export CLIENT_SECRET_FILE="${CLIENT_SECRET_FILE}"

TUNNEL_SERVICE_TOKEN_ID="$(cat "${CLIENT_ID_FILE}")"
TUNNEL_SERVICE_TOKEN_SECRET="$(cat "${CLIENT_SECRET_FILE}")"
export TUNNEL_SERVICE_TOKEN_ID TUNNEL_SERVICE_TOKEN_SECRET

ssh \
  -o ProxyCommand="cloudflared access ssh --hostname %h" \
  -p 8899 \
  -l jakeh \
  ssh.jkhmtx.com \
  "${@}"
