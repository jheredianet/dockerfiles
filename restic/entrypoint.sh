#!/bin/bash
set -e

# Abort entire script if any command fails
# S3QL_EXPORTER_ID=""
function disconnect() {
    #echo "unmounting $MOUNTPOINT"
    #/bin/fusermount -u "$MOUNTPOINT"
    echo "Exit and Stop RClone Server Success!!"
}


OPEN_FILES_DESCRIPTOR=990000
ulimit -n $OPEN_FILES_DESCRIPTOR

#echo "mount rclone '$MOUNTCONFIG' drive to $S3QL_MOUNTPOINT"
# Convertimos a segundos
mkdir -p "$MOUNTPOINT"
mkdir -p "$CACHE_FOLDER"

# Make sure the file system is unmounted when we are done
# Note that this overwrites the earlier trap, so we
# also delete the lock file here.
trap disconnect  SIGINT
trap disconnect  SIGTERM


#/usr/bin/rclone serve restic \
#    --config $CONFIG \
#    --stats 10m \
#    --log-file "$LOGFILE" \
#    $MOUNTCONFIG:$SERVERPATH & wait
    
tail -f "$LOGFILE" & wait