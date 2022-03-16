-- Criar usuário Laravel se não existir
CREATE USER IF NOT EXISTS 'laravel'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON laravel.* TO 'laravel'@'%';
FLUSH PRIVILEGES;

