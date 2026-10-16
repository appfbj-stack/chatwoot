#!/bin/bash
# Kairos CRM — Deploy script completo no VPS
# Uso: bash deploy-kairos-crm.sh

set -e

APP_DIR="/opt/kairos-crm"
VPS_USER="${VPS_USER:-root}"
COMPOSE_FILE="docker-compose.kairos-crm.yml"

echo "=== Kairos CRM Deploy ==="

# 1. Sync código (assume git pull)
if [ -d "$APP_DIR/.git" ]; then
  echo "[1/6] git pull..."
  cd "$APP_DIR"
  git pull origin develop
else
  echo "[1/6] Clone fresh..."
  git clone https://github.com/appfbj-stack/chatwoot.git "$APP_DIR"
  cd "$APP_DIR"
  git checkout develop
fi

# 2. Build imagem
echo "[2/6] docker build..."
DOCKER_BUILDKIT=0 docker build -t kairos-crm:latest -f Dockerfile .

# 3. Migrations
echo "[3/6] rails db:migrate..."
docker run --rm \
  -e DATABASE_URL="$DATABASE_URL" \
  -e RAILS_ENV=production \
  -e SECRET_KEY_BASE="$SECRET_KEY_BASE" \
  kairos-crm:latest \
  bundle exec rails db:migrate

# 4. Restart containers
echo "[4/6] docker compose up..."
docker compose -f "$COMPOSE_FILE" -p kairos-crm-prod up -d --force-recreate --no-deps

# 5. Caddy vhost
echo "[5/6] Caddy vhost..."
if [ -f deploy/caddy-add-chat-vhost.sh ]; then
  bash deploy/caddy-add-chat-vhost.sh
fi

# 6. Smoke test
echo "[6/6] Smoke test..."
sleep 30
curl -fsS "https://chat.fbautomacao.space/api/v1/accounts" -o /dev/null -w "HTTP %{http_code}\n" || echo "Smoke test falhou (esperado se SSL ainda propagando)"

echo ""
echo "=== Deploy completo ==="
echo "URL: https://chat.fbautomacao.space"
echo "Login: /app/login (criar super admin via rails console)"
