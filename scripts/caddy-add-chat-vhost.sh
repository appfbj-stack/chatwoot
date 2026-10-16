#!/bin/bash
# Kairos CRM — Caddy vhost add script
# Adiciona o subdomínio chat.fbautomacao.space no Caddy do VPS
# Uso: bash caddy-add-chat-vhost.sh

set -e

CADDY_FILE="/etc/caddy/Caddyfile"
APP_PORT="${APP_PORT:-3030}"
VHOST="chat.fbautomacao.space"

# Sanity check
if ! command -v caddy >/dev/null 2>&1; then
  echo "ERRO: caddy nao encontrado no PATH"
  exit 1
fi

# Backup
cp "$CADDY_FILE" "${CADDY_FILE}.bak.$(date +%s)"

# Adiciona vhost (se nao existir)
if grep -q "$VHOST" "$CADDY_FILE"; then
  echo "Vhost $VHOST ja existe. Pulando."
else
  cat >> "$CADDY_FILE" <<EOF

# Kairos CRM — Atendimento
$VHOST {
    encode gzip zstd
    reverse_proxy 127.0.0.1:$APP_PORT {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-For {header.X-Forwarded-For}
        header_up X-Forwarded-Proto {scheme}
    }
    log {
        output file /var/log/caddy/kairos-crm.log {
            roll_size 10mb
            roll_keep 5
        }
    }
}
EOF
  echo "Vhost $VHOST adicionado (porta $APP_PORT)."
fi

# Reload Caddy
caddy reload --config "$CADDY_FILE"
echo "Caddy recarregado. Teste: curl -I https://$VHOST/api/v1/accounts"
