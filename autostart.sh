#!/bin/sh

# Newznab variables 
NN_PATH="/var/www/newznab/misc/update_scripts"
NN_BINUP="update_binaries_threaded.php"
NN_RELUP="update_releases.php"
NN_OPTUP="optimise_db.php"
NN_PREUP="update_predb.php"
NN_TVUP="update_tvschedule.php"
NN_THRUP="update_theaters.php"
NN_SLEEP_TIME="10"
NN_PID_PATH="/var/run/" 
PIDFILE="newznab_binup.pid"

test -f /lib/lsb/init-functions || exit 1
. /lib/lsb/init-functions



case "$1" in
  start)
        [ -f ${NN_PID_PATH}${PIDFILE} ] && { echo "$0 is already ruNNing."; false; }
        echo -n "Starting Newznab binaries update"
        cd ${NN_PATH}
        (while (true);do cd ${NN_PATH} && \
        php ${NN_BINUP}  2>&1 > /dev/null && \
        php ${NN_RELUP}  2>&1 > /dev/null && \
        php ${NN_OPTUP}  2>&1 > /dev/null && \
        php ${NN_TVUP}  2>&1 > /dev/null && \
        php ${NN_THRUP}  2>&1 > /dev/null && \
        php ${NN_PREUP}  2>&1 > /dev/null ; sleep ${NN_SLEEP_TIME} ;done) &
        PID=`echo $!`
        echo $PID > ${NN_PID_PATH}${PIDFILE}
        ;;
  stop)
        echo -n "Stopping Newznab binaries update"
        kill -9 `cat ${NN_PID_PATH}${PIDFILE}`
        ;;

  *)
        echo "Usage: $0 [start|stop]"
        exit 1
esac
