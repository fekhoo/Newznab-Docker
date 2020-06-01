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

#Add newznab processing & Config script
COPY start.sh start.sh
RUN chmod u+x /start.sh

# RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

VOLUME /var/www/newznab/nzbfiles
VOLUME /var/www/newznab/www/covers

CMD ["/usr/bin/supervisord"]
