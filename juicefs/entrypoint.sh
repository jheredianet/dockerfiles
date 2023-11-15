#!/bin/bash
set -e

# Abort entire script if any command fails
# S3QL_EXPORTER_ID=""
function disconnect() {
    echo "unmounting $MOUNTPOINT"
    juicefs umount --flush "$MOUNTPOINT"
    sleep 1
    if [ -f "/config/redis.conf" ]; then
        redis-cli --no-auth-warning -h localhost -p $REDIS_PORT -a $REDIS_PASS shutdown
    fi
    echo "Stop Success!!"
}

export OPEN_FILES_DESCRIPTOR=999999
ulimit -n $OPEN_FILES_DESCRIPTOR

# Cache Size 
export CACHE_SIZE=$((${CACHE_SIZE}*1024))

# Log Files
mkdir -p "$CACHE_PATH"
export REDIS_LOGFILE="$CACHE_PATH/redis.log"
export RCLONE_LOGFILE="$CACHE_PATH/rclone.log"
export JUICE_LOGFILE="$CACHE_PATH/juiceFS.log"

# Update log files
touch $REDIS_LOGFILE
touch $RCLONE_LOGFILE
touch $JUICE_LOGFILE

# Enable Redis
if [ -f "/config/redis.conf" ]; then
    export REDIS_PASS=$(cat /config/redis.conf | grep requirepass | cut -d' ' -f 2)
    export REDIS_PORT=$(cat /config/redis.conf | grep port | cut -d' ' -f 2)
    #sysctl vm.overcommit_memory=1
    #echo never | tee /sys/kernel/mm/transparent_hugepage/enabled
    #echo never | tee /sys/kernel/mm/transparent_hugepage/defrag
    redis-server /config/redis.conf --logfile $REDIS_LOGFILE &
    sleep 1
    while true; do
        sleep 1
        if redis-cli --no-auth-warning -h localhost -p $REDIS_PORT -a $REDIS_PASS ping | grep -q "PONG"; then
            break
        fi
    done
fi

# Enable Webdav
if [[ -n "$MOUNTCONFIG" ]]
then
    rclone serve webdav \
        --config $CONFIG \
        --addr localhost:8080 \
        --log-file="$RCLONE_LOGFILE" \
        $RCLONE_OPTIONS \
        $MOUNTCONFIG:$MOUNTPATH & 
    sleep 5 
fi
# Create a temporary mountpoint and mount file system
mkdir -p "$MOUNTPOINT"

juicefs mount -d -o allow_other \
    $JUICEFS_OPTIONS --log $JUICE_LOGFILE \
    --cache-dir $CACHE_PATH \
    --cache-size $CACHE_SIZE \
    $META_DATA $MOUNTPOINT

echo "juiceFS mounted at $MOUNTPOINT"

trap disconnect  SIGINT
trap disconnect  SIGTERM

tail -f "$REDIS_LOGFILE" "$RCLONE_LOGFILE" "$JUICE_LOGFILE" & wait