#!/bin/bash

# Script helper para instalar dependências do Composer no container Docker
# Uso: ./docker/composer-install.sh

set -e

echo "📦 Instalando dependências do Composer..."

# Executa composer install como root para garantir permissões
docker exec -u root spa-laravel-php composer install --no-interaction

# Obtém UID e GID do usuário atual
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

echo "🔧 Ajustando permissões do diretório vendor para o usuário $CURRENT_UID:$CURRENT_GID..."

# Ajusta permissões do vendor para o usuário do host
docker exec -u root spa-laravel-php chown -R $CURRENT_UID:$CURRENT_GID /var/www/html/vendor

echo "✅ Dependências instaladas com sucesso!"

