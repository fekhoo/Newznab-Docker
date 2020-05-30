#!/usr/bin/env bash
set -e
  export NEWZPATH="/var/www/newznab"
  export NEWZNAB_PATH="/var/www/newznab/misc/update_scripts"
  export NEWZNAB_SLEEP_TIME="10" # in seconds
  LASTOPTIMIZE=`date +%s`

#updates to newest svn
svn co --force --username $NNUSER --password $NNPASS svn://svn.newznab.com/nn/branches/nnplus $NEWZPATH/

sleep 5s

#force download/overwrite of current svn
svn export --force --username $NNUSER --password $NNPASS svn://svn.newznab.com/nn/branches/nnplus $NEWZPATH/

#update db to current rev
cd $NEWZPATH"/misc/update_scripts"
$PHP update_database_version.php

sleep 5s

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
