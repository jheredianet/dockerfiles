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

# Make sure the file system is unmounted when we are done
# Note that this overwrites the earlier trap, so we
# also delete the lock file here.
trap disconnect  SIGINT
trap disconnect  SIGTERM


/usr/bin/rclone serve restic \
    --config $CONFIG \
    --stats 0 \
    --log-file "$LOGFILE" \
    --log-level INFO \
    $MOUNTCONFIG:$SERVERPATH & 
    
tail -f "$LOGFILE" & wait

#/usr/bin/rclone mount --rc --allow-other \
#    --fast-list --log-level INFO \
#    --vfs-read-chunk-size-limit off \
#    --poll-interval 0 \
#    --buffer-size $BUFFER_SIZE \
#    --dir-cache-time $DIR_CACHE_TIME \
#    --drive-chunk-size $DRIVE_CHUNK_SIZE \
#    --vfs-read-chunk-size $VFS_READ_CHUNK_SIZE \
#    --config $CONFIG \
#    $MOUNTCONFIG:/ "$MOUNTPOINT" & wait
