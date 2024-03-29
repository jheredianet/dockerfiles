#!/bin/bash
set -e

# Abort entire script if any command fails
# S3QL_EXPORTER_ID=""
function disconnect() {
    #echo "unmounting $MOUNTPOINT"
    #/bin/fusermount -u "$MOUNTPOINT"
<<<<<<< HEAD:borg/entrypoint.sh
    echo "Exit and Stop borg/rclone success!!" >> "$RCLONE_LOG_FILE"
=======
    echo "Exit and Stop restic/rclone success!!"
>>>>>>> origin/restic:restic/entrypoint.sh
}

# Preparamos carpetas para cache
TMPDIR="$CACHE_FOLDER/usercache" 
mkdir -p "$MOUNTPOINT"
mkdir -p "$CACHE_FOLDER"
mkdir -p "$TMPDIR"
    
# If not exist user cache folder link to TMPDIR
USER_CACHE_FOLDER="$HOME/.cache"
if [ ! -d "$USER_CACHE_FOLDER" ]; then
    ln  -s "$TMPDIR" "$USER_CACHE_FOLDER"
fi

echo "Starting container: $(date)" 
echo "Checking for 'restic' updates..." 
/usr/bin/restic self-update
rclone version 
restic version 

# Make sure the file system is unmounted when we are done
# Note that this overwrites the earlier trap, so we
# also delete the lock file here.
trap disconnect  SIGINT
trap disconnect  SIGTERM
<<<<<<< HEAD:borg/entrypoint.sh
    
tail -f "$RCLONE_LOG_FILE" & wait


# Just do what we are asked for
# exec "$@"
=======

# Execute rclone on backgroud and leave logs in a file
rclone serve restic \
    --config $RCLONE_CONFIG \
    --stats-log-level $STATS_LOG_LEVEL \
    --log-file "$RCLONE_LOG_FILE" \
    --stats 10m \
    --b2-hard-delete \
    $RCLONE_PARAMETERS \
    $MOUNTCONFIG:$SERVERPATH &

# Mostar logs y esperar hasta que se detenga el docker
tail -f "$RCLONE_LOG_FILE" & wait
>>>>>>> origin/restic:restic/entrypoint.sh
