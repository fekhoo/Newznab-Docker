FROM ubuntu:latest 
MAINTAINER Fekhoo <fekhoo@fekhoo.net>
ARG DEBIAN_FRONTEND=noninteractive

#Add Variables
ENV TZ="America/New_York" 
    
#Install required packages
RUN apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get install -qy ssh screen tmux apache2 php php-fpm php-pear php-gd \
    php-mysql php-memcache php-curl php-json php-mbstring unrar lame mediainfo \
    subversion ffmpeg memcached nano supervisor

#Add Apache config file
COPY newznab.conf /etc/apache2/sites-available/newznab.conf

#Add Newznab Config File  
COPY config.php /config/config.php
RUN chmod 777 /config/config.php

#Add newznab processing & Config script
COPY newznab.sh newznab.sh
RUN chmod a+x /newznab.sh

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

VOLUME ["/var/www/newznab/nzbfiles/", "/var/www/newznab/www/covers", "/config"]

CMD ["/usr/bin/supervisord"]
