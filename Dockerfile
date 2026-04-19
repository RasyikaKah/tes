FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    unzip curl git zip \
    libzip-dev nodejs npm

RUN docker-php-ext-install pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# penting: copy package.json dulu
COPY package.json package-lock.json ./
RUN npm install

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN npm run build

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000