FROM ubuntu:latest 
MAINTAINER Fekhoo <fekhoo@fekhoo.net>
ARG DEBIAN_FRONTEND=noninteractive

# Add Variables
ENV NNUSER="svnplus" \
    NNPASS="svnplu5" \
    TZ="America/New_York" 
    
# Install required packages
RUN apt-get -y update && \
    apt-get install -yq ssh screen tmux apache2 php php-fpm \
    php-pear php-gd php-mysql php-memcache php-curl php-json php-mbstring \
    unrar lame mediainfo subversion ffmpeg memcached nano supervisor
    
# Creating Newznab Folders from SVN
RUN mkdir /var/www/newznab/ && \
    svn export --no-auth-cache --force --username $NNUSER --password $NNPASS svn://svn.newznab.com/nn/branches/nnplus /var/www/newznab/ && \
    chmod 777 /var/www/newznab/www/lib/smarty/templates_c && \
    chmod 777 /var/www/newznab/www/covers/movies && \
    chmod 777 /var/www/newznab/www/covers/anime  && \
    chmod 777 /var/www/newznab/www/covers/music  && \
    chmod 777 /var/www/newznab/www/covers/tv && \
    chmod 777 /var/www/newznab/www  && \
    chmod 777 /var/www/newznab/www/install  && \
    chmod -R 777 /var/www/newznab/nzbfiles && \
    chmod -R 777 /var/www/newznab/www/covers
    

#Add Newznab Config File  
COPY config.php /var/www/newznab/www/config.php
RUN chmod 777 /var/www/newznab/www/config.php

# Update php.ini file
RUN sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/fpm/php.ini && \
    echo "date.timezone = $TZ" >> /etc/php/7.4/fpm/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/cli/php.ini && \
    echo "date.timezone = $TZ" >> /etc/php/7.4/cli/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/apache2/php.ini && \
    sed -i "s/memory_limit = 128M/memory_limit = -1/" /etc/php/7.4/apache2/php.ini && \
    echo "date.timezone = $TZ" >> /etc/php/7.4/apache2/php.ini

# Configure Apache for Newznab site
COPY newznab.conf /etc/apache2/sites-available/newznab.conf
RUN a2dissite 000-default.conf && \
    a2ensite newznab.conf

# Enable apache mod_rewrite, fpm and restart services
RUN a2enmod proxy_fcgi setenvif && \
    a2enconf php7.4-fpm && \
    a2enmod rewrite && \
    service php7.4-fpm reload && \
    service apache2 restart

#Add newznab processing & Config script
COPY start.sh /start.sh
RUN chmod u+x /start.sh
COPY autostart.sh /etc/init.d/autostart.sh
RUN chmod u+x /etc/init.d/autostart.sh
RUN update-rc.d autostart.sh defaults

EXPOSE 80

VOLUME /var/www/newznab/nzbfiles
VOLUME /var/www/newznab/www/covers

ENTRYPOINT ["/start.sh"]
