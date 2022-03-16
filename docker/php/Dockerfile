FROM php:8.2-fpm

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Composer
COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

# Instalar Node.js 18 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Configurar npm para usar cache no diretório do projeto (acessível por www-data)
RUN npm config set cache /var/www/html/.npm --global && \
    npm config set prefix /var/www/html/.npm-global --global && \
    rm -rf /root/.npm 2>/dev/null || true

# Garantir que o diretório de cache npm tenha permissões corretas
RUN mkdir -p /var/www/html/.npm && \
    chown -R www-data:www-data /var/www/html/.npm

# Definir diretório de trabalho
WORKDIR /var/www/html

# Copiar script de entrada
COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Copiar permissões e configurações
RUN chown -R www-data:www-data /var/www/html

# Definir entrypoint e CMD
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]

