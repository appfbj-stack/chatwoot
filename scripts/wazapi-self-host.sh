#!/bin/bash
# Kairos CRM — Wazapi self-host setup
# Roda Wazapi como container no Dokploy
# Uso: bash wazapi-self-host.sh

set -e

CONTAINER_NAME="kairos-wazapi"
IMAGE="wazapilabs/wazapi:latest"
PORT="${WAZAPI_PORT:-8080}"
DATA_DIR="/opt/kairos-wazapi/data"

# Cria dir de dados
mkdir -p "$DATA_DIR"

# Verifica se ja existe
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container $CONTAINER_NAME ja existe. Reiniciando..."
  docker restart "$CONTAINER_NAME"
else
  echo "Criando container $CONTAINER_NAME..."
  docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p "127.0.0.1:${PORT}:8080" \
    -v "${DATA_DIR}:/app/data" \
    -e NODE_ENV=production \
    -e TZ=America/Sao_Paulo \
    --network dokploy-network \
    "$IMAGE"
fi

# Espera inicializar
echo "Aguardando Wazapi inicializar..."
sleep 15

# Mostra status
docker ps --filter "name=$CONTAINER_NAME" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
echo ""
echo "Acesse a UI/admin do Wazapi em http://127.0.0.1:${PORT}"
echo "Para criar instance: curl -X POST http://127.0.0.1:${PORT}/instances -H 'Content-Type: application/json' -d '{\"name\":\"kairos-prod\"}'"
