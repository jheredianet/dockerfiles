#!/bin/bash
set -e

# Abort entire script if any command fails
# S3QL_EXPORTER_ID=""
function disconnect() {
    echo "unmounting $MOUNTPOINT"
    juicefs umount --force "$MOUNTPOINT"
    echo "Stop Success!!"
}

# Cache Size
export CACHE_SIZE=$((${CACHE_SIZE}*1024*1024))

# Log Files
mkdir -p "$CACHE_PATH"
export REDIS_LOGFILE="$CACHE_PATH/redis.log"
export RCLONE_LOGFILE="$CACHE_PATH/rclone.log"
export JUICE_LOGFILE="$CACHE_PATH/juiceFS.log"

# Update log files
touch $REDIS_LOGFILE
touch $RCLONE_LOGFILE
touch $JUICE_LOGFILE

# Create a temporary mountpoint and mount file system
mkdir -p "$MOUNTPOINT"
echo "mount juiceFS to $MOUNTPOINT"

# Enable Redis
if [ -f "/config/redis.conf" ]; then
    sysctl vm.overcommit_memory=1
    redis-server /config/redis.conf --logfile $REDIS_LOGFILE &
    sleep 5 
fi

# Enable Webdav
if [[ -n "$MOUNTCONFIG" ]]
then
    rclone serve webdav \
        --config $CONFIG \
        --addr localhost:8080 \
        --log-file="$RCLONE_LOGFILE" \
        $MOUNTCONFIG:$MOUNTPATH & 
    sleep 5 
fi

juicefs mount -d -o allow_other \
    --writeback --log $JUICE_LOGFILE \
    --cache-dir $CACHE_PATH \
    --cache-size $CACHE_SIZE \
    $META_DATA $MOUNTPOINT

trap disconnect  SIGINT
trap disconnect  SIGTERM

tail -f "$REDIS_LOGFILE" "$RCLONE_LOGFILE" "$JUICE_LOGFILE" & wait