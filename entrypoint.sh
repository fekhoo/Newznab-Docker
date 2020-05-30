
#!/bin/sh

# Creating Newznab Folders from SVN
echo "Creating newznab folder, make sure you link your NZB and cover folders or they will be deleted!!"
svn co --username $NNUSER --password $NNPASS svn://svn.newznab.com/nn/branches/nnplus /var/www/newznab/ && \
chmod 777 /var/www/newznab/www/lib/smarty/templates_c && \
chmod 777 /var/www/newznab/www  && \
chmod 777 /var/www/newznab/www/install  && \
chmod 777 /var/www/newznab/nzbfiles/ && \
chmod 777 /var/www/newznab/www/covers/movies && \
chmod 777 /var/www/newznab/www/covers/anime  && \
chmod 777 /var/www/newznab/www/covers/music  && \
chmod 777 /var/www/newznab/www/covers/tv 
    
# Creating Config File
if [ ! -f /var/www/newznab/www/config.php ] && [ -f /config/config.php ]; then
  cp /config/config.php /var/www/newznab/www/config.php
fi
touch /var/www/newznab/www/config.php
rm -f /var/www/newznab/www/config.php
ln -s /config/config.php /var/www/newznab/www/config.php

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

#Update php.ini file
sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/fpm/php.ini
echo "date.timezone =$TZ" >> /etc/php/7.4/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/cli/php.ini
sed -i "s/memory_limit = -1/memory_limit = 1024M/" /etc/php/7.4/cli/php.ini
echo "register_globals = Off" >> /etc/php/7.4/cli/php.ini
echo "date.timezone =$TZ" >> /etc/php/7.4/cli/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/apache2/php.ini
sed -i "s/memory_limit = -1/memory_limit = 1024M/" /etc/php/7.4/apache2/php.ini
echo "register_globals = Off" >> /etc/php/7.4/apache2/php.ini
echo "date.timezone =$TZ" >> /etc/php/7.4/apache2/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 1024M/" /etc/php/7.4/apache2/php.ini

# Configer Apache and restarting services
cp /newznab.conf /etc/apache2/sites-available/newznab.conf
a2dissite 000-default.conf
a2ensite newznab
a2enmod proxy_fcgi setenvif
a2enconf php7.4-fpm
a2enmod rewrite
service apache2 restart
