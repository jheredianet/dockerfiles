#!/bin/bash
set -e

# Abort entire script if any command fails
# S3QL_EXPORTER_ID=""
function disconnect() {
    #echo "unmounting $MOUNTPOINT"
    #/bin/fusermount -u "$MOUNTPOINT"
    echo "Exit and Stop restic/rclone success!!" >> "$RCLONE_LOG_FILE"
}

#echo "mount rclone '$MOUNTCONFIG' drive to $S3QL_MOUNTPOINT"
# Convertimos a segundos
mkdir -p "$MOUNTPOINT"
mkdir -p "$CACHE_FOLDER"
mkdir -p "$TMPDIR"

# If not exist user cache folder link to TMPDIR
USER_CACHE_FOLDER="$HOME/.cache"
if [ ! -d "$USER_CACHE_FOLDER" ]; then
    ln  -s "$TMPDIR" "$USER_CACHE_FOLDER"
fi

echo "Starting container: $(date)" >> "$RCLONE_LOG_FILE"
echo "Checking for 'restic' updates..." >> "$RCLONE_LOG_FILE"
/usr/bin/restic self-update
rclone version >> "$RCLONE_LOG_FILE"
restic version >> "$RCLONE_LOG_FILE"

# Make sure the file system is unmounted when we are done
# Note that this overwrites the earlier trap, so we
# also delete the lock file here.
trap disconnect  SIGINT
trap disconnect  SIGTERM
    
tail -f "$RCLONE_LOG_FILE" & wait
