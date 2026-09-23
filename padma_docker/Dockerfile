FROM php:8.3-cli

# প্রয়োজনীয় ডিপেনডেন্সি ও এক্সটেনশন ইনস্টল
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer কপি
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# প্রজেক্ট কোড কপি
COPY . .

# ডিপেনডেন্সি ইনস্টল
RUN composer install --no-dev --optimize-autoloader

# পোর্ট ওপেন
EXPOSE 8000

# php artisan serve দিয়ে সার্ভার রান (0.0.0.0 দেওয়া জরুরি যাতে ডকারের বাইরে থেকে অ্যাক্সেস করা যায়)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
