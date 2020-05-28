FROM ubuntu:latest 
MAINTAINER fekhoo@gmail.com
ARG DEBIAN_FRONTEND=noninteractive

# Add Variables SVN Password and user
ENV nn_user=svnplus 
ENV nn_pass=svnplus5
ENV php_timezone=America/New_York 
ENV path /:/var/www/html/www/

#Install required packages
RUN apt-get update && apt-get -yq install ssh screen tmux apache2 php php-fpm php-pear php-gd php-mysql php-memcache php-curl \
php-json php-mbstring unrar lame mediainfo subversion ffmpeg memcached 

#Configer Apache
ADD ./newznab.conf /etc/apache2/sites-available/newznab.conf

# Creating Newznab Folders from SVN
RUN mkdir /var/www/newznab/
RUN svn co --username $nn_user --password $nn_pass svn://svn.newznab.com/nn/branches/nnplus /var/www/newznab/
RUN chmod 777 /var/www/newznab/www/lib/smarty/templates_c && \
chmod 777 /var/www/newznab/www/covers/movies && \
chmod 777 /var/www/newznab/www/covers/anime  && \
chmod 777 /var/www/newznab/www/covers/music  && \
chmod 777 /var/www/newznab/www  && \
chmod 777 /var/www/newznab/www/install  && \
chmod 777 /var/www/newznab/nzbfiles/ 

#Update a few defaults in the php.ini file
RUN sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/fpm/php.ini  && \
echo "date.timezone =$php_timezone" >> /etc/php/7.4/fpm/php.ini 

#Enable apache mod_rewrite, fpm and restart services
RUN a2dissite 000-default.conf
RUN a2ensite newznab
RUN a2enmod proxy_fcgi setenvif
RUN a2enconf php7.4-fpm
RUN a2enmod rewrite
RUN systemctl restart php7.4-fpm
RUN systemctl restart apache2
RUN systemctl restart mysql

# add newznab config file - This needs to be edited
ADD ./config.php /var/www/newznab/www/config.php
RUN chmod 777 /var/www/newznab/www/config.php

#add newznab processing script
ADD ./newznab.sh /newznab.sh
RUN chmod 755 /*.sh

#Setup supervisor to start Apache and the Newznab scripts to load headers and build releases

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup NZB volume this will need to be mapped locally using -v command so that it can persist.
EXPOSE 80
VOLUME /nzb
WORKDIR /var/www/html/www/
#kickoff Supervisor to start the functions
CMD ["/usr/bin/supervisord"]
