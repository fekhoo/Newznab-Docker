FROM ubuntu:latest 
MAINTAINER Fekhoo <fekhoo@fekhoo.net>
ARG DEBIAN_FRONTEND=noninteractive

#Add Variables
ENV NNUSER="svnplus" \
    NNPASS="svnplu5" \
    TZ="America/New_York" 
    
#Install required packages
RUN apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get install -qy ssh screen tmux apache2 php php-fpm php-pear php-gd \
    php-mysql php-memcache php-curl php-json php-mbstring unrar lame mediainfo \
    subversion ffmpeg memcached nano supervisor

#Creating Newznab Folders from SVN
RUN mkdir /var/www/newznab/ && \
    svn co --username $NNUSER --password $NNPASS svn://svn.newznab.com/nn/branches/nnplus /var/www/newznab/ && \
    chmod 777 /var/www/newznab/www/lib/smarty/templates_c && \
    chmod 777 /var/www/newznab/www/covers/movies && \
    chmod 777 /var/www/newznab/www/covers/anime  && \
    chmod 777 /var/www/newznab/www/covers/music  && \
    chmod 777 /var/www/newznab/www  && \
    chmod 777 /var/www/newznab/www/install  && \
    chmod 777 /var/www/newznab/nzbfiles/ && \
    chmod 777 /var/www/newznab/www/covers/tv

#Add newznab processing script
ADD ./newznab.sh /newznab.sh
RUN chmod 755 /*.sh

#Update php.ini file
RUN sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/fpm/php.ini  && \
    echo "date.timezone =$TZ" >> /etc/php/7.4/fpm/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/cli/php.ini  && \
    sed -i "s/memory_limit = -1/memory_limit = 1024M/" /etc/php/7.4/cli/php.ini  && \
    echo "register_globals = Off" >> /etc/php/7.4/cli/php.ini  && \
    echo "date.timezone =$TZ" >> /etc/php/7.4/cli/php.ini  && \
    sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/apache2/php.ini  && \
    sed -i "s/memory_limit = -1/memory_limit = 1024M/" /etc/php/7.4/apache2/php.ini  && \
    echo "register_globals = Off" >> /etc/php/7.4/apache2/php.ini  && \
    echo "date.timezone =$TZ" >> /etc/php/7.4/apache2/php.ini  && \
    sed -i "s/memory_limit = 128M/memory_limit = 1024M/" /etc/php/7.4/apache2/php.ini

#Configer Apache
ADD ./newznab.conf /etc/apache2/sites-available/newznab.conf

#Enable apache mod_rewrite, fpm and restart services
RUN a2dissite 000-default.conf && \
    a2ensite newznab && \
    a2enmod proxy_fcgi setenvif && \
    a2enconf php7.4-fpm && \
    a2enmod rewrite && \
    service apache2 restart
    
#Adding Config File    
COPY ./config.php /var/www/newznab/www/config.php
RUN chmod 777 /var/www/newznab/www/config.php
    
#Data Base 
RUN sed -i "s/'mysql'/'$DB_TYPE'/" /var/www/newznab/www/config.php && \
    sed -i "s/'localhost'/'$DB_HOST'/" /var/www/newznab/www/config.php && \
    sed -i "s/3306/$DB_PORT/" /var/www/newznab/www/config.php && \
    sed -i "s/'root'/'$DB_USER'/" /var/www/newznab/www/config.php && \
    sed -i "s/'password'/'$DB_PASSWORD'/" /var/www/newznab/www/config.php && \
    sed -i "s/'newznab'/'$DB_NAME'/" /var/www/newznab/www/config.php

#Usenet Server
RUN sed -i "s/'nnuser'/'$NNTP_USERNAME'/" /var/www/newznab/www/config.php && \
sed -i "s/'nnpass'/'$NNTP_PASSWORD'/" /var/www/newznab/www/config.php && \
sed -i "s/'nnserver'/'$NNTP_SERVER'/" /var/www/newznab/www/config.php && \
sed -i "s/563/$NNTP_PORT/" /var/www/newznab/www/config.php && \
sed -i "s/'NNTP_SSLENABLED', true/'NNTP_SSLENABLED', $NNTP_SSLENABLED/" /var/www/newznab/www/config.php   


RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
WORKDIR /


CMD ["/usr/bin/supervisord"]
