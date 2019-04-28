#!/bin/bash
set -e

# Abort entire script if any command fails
# S3QL_EXPORTER_ID=""
function disconnect() {
    #echo "unmounting $MOUNTPOINT"
    #/bin/fusermount -u "$MOUNTPOINT"
    echo "Exit and Stop restic/rclone success!!"
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
    
rclone serve restic \
    --config $RCLONE_CONFIG \
    --stats 10m \
    -v --b2-hard-delete \
    $RCLONEPARAMETERS \
    $MOUNTCONFIG:$SERVERPATH 