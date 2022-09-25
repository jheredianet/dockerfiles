#!/bin/bash
set -e

# Abort entire script if any command fails
function disconnect() {
    echo "unmounting $MOUNTPOINT"
    /bin/fusermount -u "$MOUNTPOINT"
    echo "Umount Success!!"
}

OPEN_FILES_DESCRIPTOR=990000
ulimit -n $OPEN_FILES_DESCRIPTOR

echo "Updating restic & rclone tools and dependencies"
apt-get update -qq && apt-get upgrade -yy -qq
restic self-update

echo "Preparing volumen on $MOUNTPOINT"
# Make sure the file system is unmounted when we are done
# Note that this overwrites the earlier trap, so we
# also delete the lock file here.
trap disconnect  SIGINT
trap disconnect  SIGTERM

restic mount \
    --allow-other=true \
    --cache-dir /tmp \
    "$MOUNTPOINT" >"$RCLONE_LOG_FILE" & 

tail -f "$RCLONE_LOG_FILE" & wait
