#!/bin/sh

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
