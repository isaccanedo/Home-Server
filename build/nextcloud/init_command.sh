#!/bin/bash
set -e

function main {
    rm -rf /etc/nginx/conf.d/default.conf

    if [ "$SSL_CERT_MODE" = 'Yes' ]; then
        nginx_prod
    elif [ "$SSL_CERT_MODE" = 'SelfSigned' ]; then
        nginx_dev
    fi

    envsubst < /usr/share/nginx/nextcloud.template.conf > /etc/nginx/conf.d/nextcloud.conf

    service php7.4-fpm start;
    nginx -g 'daemon off;'
}

function nginx_dev {
    # Ensure required directories exist
    mkdir -p /etc/letsencrypt/live/${NEXTCLOUD_DOMAIN}/
    # Create self-signed certificates
    if [ ! -f /etc/letsencrypt/live/${NEXTCLOUD_DOMAIN}/privkey.pem ]; then
        openssl req -x509 -newkey rsa:4096 \
                    -keyout /etc/letsencrypt/live/${NEXTCLOUD_DOMAIN}/privkey.pem \
                    -out /etc/letsencrypt/live/${NEXTCLOUD_DOMAIN}/fullchain.pem \
                    -days 365 -nodes -subj '/CN=atb00ker'
    fi
}

function nginx_prod {
    if [ ! -f /etc/letsencrypt/live/${NEXTCLOUD_DOMAIN}/privkey.pem ]; then
        certbot certonly --standalone --noninteractive --agree-tos \
                        --rsa-key-size 4096 \
                        --domain ${NEXTCLOUD_DOMAIN} \
                        --email ${LETSENCRYPT_ADMIN_EMAIL}
    fi
    CMD="certbot --nginx renew && nginx -s reload"
    echo "0 3 * * 7 ${CMD} &>> /etc/nginx/log/crontab.log" | crontab -
}

main
