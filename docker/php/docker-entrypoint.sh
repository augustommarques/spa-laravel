#!/bin/bash
set -e

# Criar diretórios necessários se não existirem
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/storage/framework/cache
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/bootstrap/cache
mkdir -p /var/www/html/resources/markdown
mkdir -p /var/www/html/vendor

# Obter UID e GID do proprietário do diretório (do host)
if [ -d /var/www/html ]; then
    HOST_UID=$(stat -c "%u" /var/www/html 2>/dev/null || echo "33")
    HOST_GID=$(stat -c "%g" /var/www/html 2>/dev/null || echo "33")
    
    # Configurar permissões: owner do host, grupo www-data (para permitir escrita pelo PHP)
    # Isso permite que o host e o container compartilhem os arquivos
    chown -R ${HOST_UID}:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/app /var/www/html/database 2>/dev/null || true
    chown -R ${HOST_UID}:${HOST_GID} /var/www/html/resources /var/www/html/vendor 2>/dev/null || true
    
    # Garantir permissões de escrita para o grupo (775 = rwxrwxr-x)
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/app /var/www/html/database 2>/dev/null || true
    chmod -R 775 /var/www/html/resources /var/www/html/vendor 2>/dev/null || true
    
    # Criar arquivo de log se não existir e garantir permissões
    touch /var/www/html/storage/logs/laravel.log 2>/dev/null || true
    chown ${HOST_UID}:www-data /var/www/html/storage/logs/laravel.log 2>/dev/null || true
    chmod 664 /var/www/html/storage/logs/laravel.log 2>/dev/null || true
    
    # Ajustar permissões do arquivo .env para permitir escrita pelo PHP
    if [ -f /var/www/html/.env ]; then
        chown ${HOST_UID}:www-data /var/www/html/.env 2>/dev/null || true
        chmod 664 /var/www/html/.env 2>/dev/null || true
    fi
else
    # Fallback: usar www-data se não conseguir detectar o host
    chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/app /var/www/html/database /var/www/html/resources /var/www/html/vendor 2>/dev/null || true
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/app /var/www/html/database /var/www/html/vendor 2>/dev/null || true
    chmod -R 775 /var/www/html/resources 2>/dev/null || true
    
    # Criar arquivo de log se não existir
    touch /var/www/html/storage/logs/laravel.log 2>/dev/null || true
    chown www-data:www-data /var/www/html/storage/logs/laravel.log 2>/dev/null || true
    chmod 664 /var/www/html/storage/logs/laravel.log 2>/dev/null || true
    
    # Ajustar permissões do arquivo .env
    if [ -f /var/www/html/.env ]; then
        chown www-data:www-data /var/www/html/.env 2>/dev/null || true
        chmod 664 /var/www/html/.env 2>/dev/null || true
    fi
fi

# Executar comando original
exec "$@"

