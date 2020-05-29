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
    subversion ffmpeg memcached supervisor nano

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

#Update a few defaults in the php.ini file
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

# add newznab config file - This needs to be edited
ADD ./config.php /var/www/newznab/www/config.php
RUN chmod 777 /var/www/newznab/www/config.php

#Setup supervisor to start Apache and the Newznab scripts to load headers and build releases
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup NZB volume this will need to be mapped locally using -v command so that it can persist.
EXPOSE 80
VOLUME /nzb
WORKDIR /var/www/newznab/misc/update_scripts

#kickoff Supervisor to start the functions
CMD ["/usr/bin/supervisord"]
