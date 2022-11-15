#!/bin/bash
set -e

sed -i "\$i 'memcache.distributed' => '\\\OC\\\Memcache\\\Redis'," /usr/share/nginx/nextcloud/config/config.php
sed -i "\$i 'memcache.local' => '\\\OC\\\Memcache\\\Redis'," /usr/share/nginx/nextcloud/config/config.php
sed -i "\$i 'memcache.locking' => '\\\OC\\\Memcache\\\Redis'," /usr/share/nginx/nextcloud/config/config.php
sed -i "\$i 'redis' => array(" /usr/share/nginx/nextcloud/config/config.php
sed -i "\$i      'host' => 'redis'," /usr/share/nginx/nextcloud/config/config.php
sed -i "\$i      'port' => 6379," /usr/share/nginx/nextcloud/config/config.php
sed -i "\$i      )," /usr/share/nginx/nextcloud/config/config.php
sed -i "\$i 'simpleSignUpLink.shown' => false," /usr/share/nginx/nextcloud/config/config.php
service php7.4-fpm restart
/etc/init.d/nginx reload


