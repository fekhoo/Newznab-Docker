
# Update php.ini file
RUN sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/fpm/php.ini && \
    echo "date.timezone = $TZ" >> /etc/php/7.4/fpm/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/cli/php.ini && \
    echo "date.timezone = $TZ" >> /etc/php/7.4/cli/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php/7.4/apache2/php.ini && \
    sed -i "s/memory_limit = 128M/memory_limit = -1/" /etc/php/7.4/apache2/php.ini && \
    echo "date.timezone = $TZ" >> /etc/php/7.4/apache2/php.ini
    
# Enable apache mod_rewrite, fpm and restart services
RUN a2enmod proxy_fcgi setenvif && \
    a2enconf php7.4-fpm && \
    a2enmod rewrite && \
    service php7.4-fpm reload && \
    service apache2 restart
