#!/bin/sh
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

rclone selfupdate

# Cargar secretos desde el archivo
rclone serve webdav --addr :$WEB_PORT \
    --user $HTTP_USER \
    --pass $HTTP_PASS \
    --log-file=$RCLONE_LOG_FILE \
    --log-level $RCLONE_LOG_LEVEL \
    --umask 000 \
    --rc \
    --rc-web-gui \
    --rc-addr :$RC_PORT \
    --rc-web-gui-no-open-browser \
    --rc-user=$HTTP_USER \
    --rc-pass=$HTTP_PASS \
    $PATH_TO_SERVE &

tail -f $RCLONE_LOG_FILE