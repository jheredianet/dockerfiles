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

# Log File
export LOGFILE="$CACHE_PATH/juiceFS.log"
mkdir -p "$CACHE_PATH"

# Create a temporary mountpoint and mount file system
mkdir -p "$MOUNTPOINT"
echo "mount juiceFS to $MOUNTPOINT"

# Enable Redis
sysctl vm.overcommit_memory=1
redis-server /config/redis.conf --logfile $LOGFILE &

# Enable Webdav
if [[ -n "$MOUNTCONFIG" ]]
then
    rclone serve webdav \
        --config $CONFIG \
        --addr localhost:8080 \
        --log-file="$LOGFILE" \
        $MOUNTCONFIG:$MOUNTPATH & 
fi

juicefs mount -d -o allow_other \
    --log $LOGFILE \
    --cache-dir $CACHE_PATH \
    --cache-size $CACHE_SIZE \
    $META_DATA $MOUNTPOINT

trap disconnect  SIGINT
trap disconnect  SIGTERM

tail -f "$LOGFILE" & wait