#!/bin/sh
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

echo "Updating rclone..."
rclone selfupdate

# Run rclone
echo "Running Rclone to Serve S3 files"
rclone serve s3 --addr :$WEB_PORT \
    --auth-key $ACCESS_KEY_ID,$SECRET_ACCESS_KEY \
    --log-level $RCLONE_LOG_LEVEL \
    --umask 000 \
    --rc \
    --rc-web-gui \
    --rc-addr :$RC_PORT \
    --rc-web-gui-no-open-browser \
    --rc-user=$HTTP_USER \
    --rc-pass=$HTTP_PASS \
    $PATH_TO_SERVE 
