#!/bin/bash
set -e

# Abort entire script if any command fails
function disconnect() {
    echo "unmounting $MOUNTPOINT"
    /bin/fusermount -u "$MOUNTPOINT"
    /bin/fusermount -u "$CLONE_FOLDER"
    echo "Umount Success!!"
}

OPEN_FILES_DESCRIPTOR=990000
ulimit -n $OPEN_FILES_DESCRIPTOR

echo "Preparing volumen on $MOUNTPOINT"
# Convertimos a segundos
mkdir -p "$MOUNTPOINT"
mkdir -p "$LOCAL_FOLDER"
mkdir -p "$CLONE_FOLDER"
mkdir -p "$CACHE_FOLDER"

# enable crontab
echo "0 */$HOURS_RCLONE_MOVE * * * /usr/bin/rclone move --config $CONFIG --log-file=$LOGFILE --log-level INFO --delete-empty-src-dirs --fast-list --min-age 6h $LOCAL_FOLDER/latest $MOUNTCONFIG:/latest" > /etc/cron.d/rclonemove-cron
chmod +x /etc/cron.d/rclonemove-cron
crontab /etc/cron.d/rclonemove-cron

# Make sure the file system is unmounted when we are done
# Note that this overwrites the earlier trap, so we
# also delete the lock file here.
trap disconnect  SIGINT
trap disconnect  SIGTERM

/usr/bin/rclone mount \
    --allow-other \
    --config $CONFIG \
    --cache-dir $CACHE_FOLDER \
    --log-file="$LOGFILE" \
    $BASIC_FLAGS \
    $OTHER_FLAGS \
    $MOUNTCONFIG:/ "$CLONE_FOLDER" & 

/usr/bin/mergerfs \
    "$LOCAL_FOLDER":"$CLONE_FOLDER" "$MOUNTPOINT" \
    -o rw,use_ino,allow_other,func.getattr=newest,category.action=all,category.create=ff,cache.files=auto-full

/usr/sbin/cron
tail -f "$LOGFILE" & wait
