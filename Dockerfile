FROM php:8.2-cli

WORKDIR /app

# install dependency sistem
RUN apt-get update && apt-get install -y \
    unzip curl git zip \
    libzip-dev nodejs npm

# install PHP extension
RUN docker-php-ext-install pdo pdo_mysql

# copy project
COPY . .

# install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# install backend
RUN composer install --no-dev --optimize-autoloader

# install frontend + build vite
RUN npm install
RUN npm run build

EXPOSE 10000

CMD php -S 0.0.0.0:10000 -t public