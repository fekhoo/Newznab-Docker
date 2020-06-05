#!/usr/bin/env bash

#Creating needed folders if needed
if [ ! -f /var/www/newznab/www/covers/anime ]; then 
mkdir -p /var/www/newznab/www/covers/anime
chmod  -R 777 /var/www/newznab/www/covers/anime 
fi
if [ ! -f /var/www/newznab/www/covers/music ]; then 
mkdir -p /var/www/newznab/www/covers/music
chmod  -R 777 /var/www/newznab/www/covers/music 
fi
if [ ! -f /var/www/newznab/www/covers/tv ]; then 
mkdir -p /var/www/newznab/www/covers/tv
chmod  -R 777 /var/www/newznab/www/covers/tv 
fi
if [ ! -f /var/www/newznab/www/covers/audio ]; then 
mkdir -p /var/www/newznab/www/covers/audio
chmod  -R 777 /var/www/newznab/www/covers/audio 
fi
if [ ! -f /var/www/newznab/www/covers/book ]; then 
mkdir -p /var/www/newznab/www/covers/book
chmod  -R 777 /var/www/newznab/www/covers/book 
fi
if [ ! -f /var/www/newznab/www/covers/console ]; then 
mkdir -p /var/www/newznab/www/covers/console
chmod  -R 777 /var/www/newznab/www/covers/console 
fi
if [ ! -f /var/www/newznab/www/covers/movies ]; then
mkdir -p /var/www/newznab/www/covers/movies
chmod  -R 777 /var/www/newznab/www/covers/movies
fi
if [ ! -f /var/www/newznab/www/covers/preview ]; then
mkdir -p /var/www/newznab/www/covers/preview
chmod  -R 777 /var/www/newznab/www/covers/preview
fi

# Edit config file DataBase settings
sed -i "s/'mysql'/'$DB_TYPE'/" /var/www/newznab/www/config.php
sed -i "s/'localhost'/'$DB_HOST'/" /var/www/newznab/www/config.php
sed -i "s/3306/$DB_PORT/" /var/www/newznab/www/config.php
sed -i "s/'root'/'$DB_USER'/" /var/www/newznab/www/config.php
sed -i "s/'password'/'$DB_PASSWORD'/" /var/www/newznab/www/config.php
sed -i "s/'newznab'/'$DB_NAME'/" /var/www/newznab/www/config.php

#Edit config file Usenet Server Settings
sed -i "s/'nnuser'/'$NNTP_USERNAME'/" /var/www/newznab/www/config.php
sed -i "s/'nnpass'/'$NNTP_PASSWORD'/" /var/www/newznab/www/config.php
sed -i "s/'nnserver'/'$NNTP_SERVER'/" /var/www/newznab/www/config.php
sed -i "s/563/$NNTP_PORT/" /var/www/newznab/www/config.php
sed -i "s/'NNTP_SSLENABLED', true/'NNTP_SSLENABLED', $NNTP_SSLENABLED/" /var/www/newznab/www/config.php

# Getting script ready for newznab Screen
cp /var/www/newznab/misc/update_scripts/nix_scripts/newznab_screen.sh /var/www/newznab/misc/update_scripts/nix_scripts/newznab_local.sh
sed -i "s|/var/www/newznab/htdocs/misc/update_scripts|/var/www/newznab/misc/update_scripts|" /var/www/newznab/misc/update_scripts/nix_scripts/newznab_local.sh
sed -i "s|30|10|" /var/www/newznab/misc/update_scripts/nix_scripts/newznab_local.sh
chmod a+x /var/www/newznab/misc/update_scripts/nix_scripts/newznab_local.sh

# Update php.ini file
sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/fpm/php.ini
sed -i "s/memory_limit = -1/memory_limit = 2048M/" /etc/php/7.4/fpm/php.ini
echo "date.timezone = $TZ" >> /etc/php/7.4/fpm/php.ini

sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/cli/php.ini
sed -i "s/memory_limit = -1/memory_limit = 2048M/" /etc/php/7.4/apache2/php.ini
echo "date.timezone = $TZ" >> /etc/php/7.4/cli/php.ini

sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/apache2/php.ini
sed -i "s/memory_limit = 128M/memory_limit = -1/" /etc/php/7.4/apache2/php.ini
echo "date.timezone = $TZ" >> /etc/php/7.4/apache2/php.ini
    
# Enable Newznab site, Apache mod_rewrite, fpm and restart services
a2dissite 000-default.conf
a2ensite newznab.conf
a2enmod proxy_fcgi setenvif
a2enconf php7.4-fpm
a2enmod rewrite
service php7.4-fpm reload
service memcached start
service apache2 restart

# Start newznab Service
/var/www/newznab/misc/update_scripts/nix_scripts/newznab_local.sh 2>&1 > /dev/stdout

#Keep Docker up!!
tail -f /dev/stdout /dev/stderr
