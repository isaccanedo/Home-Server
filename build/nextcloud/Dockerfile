FROM debian:bullseye-slim

WORKDIR /usr/share/nginx/

RUN apt update && \
    apt install --yes php7.4 php7.4-fpm php7.4-common php7.4-pgsql php7.4-cli php7.4-gd \
        php7.4-json php7.4-curl php7.4-zip php7.4-xml php7.4-mbstring php7.4-bz2 \
        php7.4-intl php7.4-bcmath php7.4-gmp php-imagick php7.4-opcache php-redis php7.4-readline \
        unzip curl cron nginx certbot openssl gettext-base && \
    rm -rf /var/lib/apt/lists/* /root/.cache/pip/* /tmp/*

RUN curl -o /usr/share/nginx/download.zip https://download.nextcloud.com/server/releases/latest.zip && \
    unzip download.zip -d /usr/share/nginx/ && \
    chown www-data:www-data /usr/share/nginx/nextcloud/ -R && \
    rm -rf /usr/share/nginx/download.zip

COPY ./nextcloud/nextcloud-cron \
     ./nextcloud/postsetup.sh \
     ./nextcloud/init_command.sh \
     ./nextcloud/nextcloud.template.conf /usr/share/nginx/

RUN mkdir /usr/share/nginx/nextcloud-data && \
    chown www-data:www-data /usr/share/nginx/postsetup.sh && \
    chmod 755 /usr/share/nginx/postsetup.sh && \
    chown www-data:www-data /usr/share/nginx/nextcloud-data -R && \
    echo 'memory_limit = 512M' >> /etc/php/7.4/fpm/php.ini && \
    echo 'max execution time 256' >> /etc/php/7.4/fpm/php.ini && \
    echo 'clear_env = no' >> /etc/php/7.4/fpm/pool.d/www.conf && \
    cp /usr/share/nginx/nextcloud-cron /etc/cron.d/nextcloud-cron && \
    chmod 0644 /etc/cron.d/nextcloud-cron && \
    crontab /etc/cron.d/nextcloud-cron

ENV DOLLAR=$ \
    TZ=UTC \
    SSL_CERT_MODE=SelfSigned \
    LETSENCRYPT_ADMIN_EMAIL=example@example.com

CMD ["bash", "init_command.sh"]
EXPOSE 80 443
