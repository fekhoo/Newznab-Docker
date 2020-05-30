#!/bin/sh

#Data Base 
sed -i "s/'mysql'/'$DB_TYPE'/" /var/www/newznab/www/config.php
sed -i "s/'localhost'/'$DB_HOST'/" /var/www/newznab/www/config.php
sed -i "s/3306/$DB_PORT/" /var/www/newznab/www/config.php
sed -i "s/'root'/'$DB_USER'/" /var/www/newznab/www/config.php
sed -i "s/'password'/'$DB_PASSWORD'/" /var/www/newznab/www/config.php
sed -i "s/'newznab'/'$DB_NAME'/" /var/www/newznab/www/config.php

#Usenet Server
sed -i "s/'nnuser'/'$NNTP_USERNAME'/" /var/www/newznab/www/config.php
sed -i "s/'nnpass'/'$NNTP_PASSWORD'/" /var/www/newznab/www/config.php
sed -i "s/'nnserver'/'$NNTP_SERVER'/" /var/www/newznab/www/config.php
sed -i "s/563/$NNTP_PORT/" /var/www/newznab/www/config.php
sed -i "s/'NNTP_SSLENABLED', true/'NNTP_SSLENABLED', $NNTP_SSLENABLED/" /var/www/newznab/www/config.php


  export NEWZNAB_PATH="/var/www/newznab/misc/update_scripts"
  export NEWZNAB_SLEEP_TIME="10" # in seconds
  LASTOPTIMIZE=`date +%s`

while :

 do
   CURRTIME=`date +%s`
   cd ${NEWZNAB_PATH}
   /usr/bin/php ${NEWZNAB_PATH}/update_binaries_threaded.php
   /usr/bin/php ${NEWZNAB_PATH}/backfill_threaded.php
   /usr/bin/php ${NEWZNAB_PATH}/update_releases.php

   DIFF=$(($CURRTIME-$LASTOPTIMIZE))
if [ "$DIFF" -gt 43200 ] || [ "$DIFF" -lt 1 ]
then
LASTOPTIMIZE=`date +%s`
/usr/bin/php ${NEWZNAB_PATH}/optimise_db.php
/usr/bin/php ${NEWZNAB_PATH}/update_tvschedule.php
/usr/bin/php ${NEWZNAB_PATH}/update_theaters.php
/usr/bin/php ${NEWZNAB_PATH}/update_predb.php
fi

echo "waiting ${NEWZNAB_SLEEP_TIME} seconds..."
sleep ${NEWZNAB_SLEEP_TIME}

done
