#!/usr/bin/env bash

#Creating needed folders
if [ ! -f /var/www/newznab/www/covers/anime ]; then
 mkdir -p /var/www/newznab/www/covers/anime
 chmod  -R 777 /var/www/newznab/www/covers/anime
 fi

 if [ ! -f /var/www/newznab/www/covers/music ]; then
 mkdir -p /var/www/newznab/www/covers/music
 chmod  -R 777 /var/www/newznab/www/covers/music
 fi

 if [ ! -f /var/www/newznab/www/covers/tv ]; then
 mkdir -p /var/www/newznab/www/covers/tv
 chmod  -R 777 /var/www/newznab/www/covers/tv
 fi

if [ ! -f /var/www/newznab/www/covers/audio ]; then
 mkdir -p /var/www/newznab/www/covers/audio
 chmod  -R 777 /var/www/newznab/www/covers/audio
 fi

 if [ ! -f /var/www/newznab/www/covers/book ]; then
 mkdir -p /var/www/newznab/www/covers/book
 chmod  -R 777 /var/www/newznab/www/covers/book
 fi

  if [ ! -f /var/www/newznab/www/covers/console ]; then
 mkdir -p /var/www/newznab/www/covers/console
 chmod  -R 777 /var/www/newznab/www/covers/console
 fi

 if [ ! -f /var/www/newznab/www/covers/movies ]; then
 mkdir -p /var/www/newznab/www/covers/movies
 chmod  -R 777 /var/www/newznab/www/covers/movies
 fi

if [ ! -f /var/www/newznab/www/covers/preview ]; then
 mkdir -p /var/www/newznab/www/covers/preview
 chmod  -R 777 /var/www/newznab/www/covers/preview
 fi

# Edit config file DataBase settings
sed -i "s/'mysql'/'$DB_TYPE'/" /var/www/newznab/www/config.php
sed -i "s/'localhost'/'$DB_HOST'/" /var/www/newznab/www/config.php
sed -i "s/3306/$DB_PORT/" /var/www/newznab/www/config.php
sed -i "s/'root'/'$DB_USER'/" /var/www/newznab/www/config.php
sed -i "s/'password'/'$DB_PASSWORD'/" /var/www/newznab/www/config.php
sed -i "s/'newznab'/'$DB_NAME'/" /var/www/newznab/www/config.php

sleep 1m

set -e

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
