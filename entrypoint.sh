#!/bin/bash
/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"
sleep 120s && ./newznab.sh

