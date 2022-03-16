#!/bin/bash

# Script para corrigir permissões do Laravel no container Docker
# Uso: ./docker/fix-permissions.sh

set -e

echo "🔧 Corrigindo permissões do Laravel..."

# Obtém UID e GID do usuário atual
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

echo "📁 Ajustando permissões dos diretórios necessários..."

# Ajusta permissões: owner do host, grupo www-data (para permitir escrita pelo PHP)
docker exec -u root spa-laravel-php chown -R $CURRENT_UID:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/app /var/www/html/database

# Garante permissões de escrita para o grupo (775 = rwxrwxr-x)
docker exec -u root spa-laravel-php chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/app /var/www/html/database

# Cria e ajusta permissões do arquivo de log
echo "📝 Criando arquivo de log se necessário..."
docker exec -u root spa-laravel-php touch /var/www/html/storage/logs/laravel.log
docker exec -u root spa-laravel-php chown $CURRENT_UID:www-data /var/www/html/storage/logs/laravel.log
docker exec -u root spa-laravel-php chmod 664 /var/www/html/storage/logs/laravel.log

# Ajusta permissões do arquivo .env
echo "🔐 Ajustando permissões do arquivo .env..."
if docker exec -u root spa-laravel-php test -f /var/www/html/.env; then
    docker exec -u root spa-laravel-php chown $CURRENT_UID:www-data /var/www/html/.env
    docker exec -u root spa-laravel-php chmod 664 /var/www/html/.env
fi

echo "✅ Permissões corrigidas com sucesso!"
echo ""
echo "📋 Permissões atuais:"
echo "  - storage/logs/laravel.log:"
docker exec -u root spa-laravel-php ls -la /var/www/html/storage/logs/ | grep laravel.log || echo "    Arquivo de log não encontrado"
echo "  - .env:"
docker exec -u root spa-laravel-php ls -la /var/www/html/.env 2>/dev/null || echo "    Arquivo .env não encontrado"

