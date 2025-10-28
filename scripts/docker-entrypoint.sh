#!/usr/bin/env bash
set -euo pipefail

mode="${CORS_MODE:-dispatcher}"
config_src="/etc/nginx/cors/nginx-cors-${mode}.conf"
config_dst="/etc/nginx/conf.d/nginx-cors.conf"

if [[ ! -f "${config_src}" ]]; then
  echo "Unknown CORS_MODE '${mode}'. Available modes: client, dispatcher." >&2
  exit 1
fi

cp "${config_src}" "${config_dst}"

if [[ -n "${NGINX_PROXY_CACHE_VALID_TIME:-}" ]]; then
  sed -i.bak "s/__NGINX_PROXY_CACHE_VALID_TIME__/${NGINX_PROXY_CACHE_VALID_TIME}/g" "${config_dst}"
  rm -f "${config_dst}.bak"
fi

exec nginx -g "daemon off;"

