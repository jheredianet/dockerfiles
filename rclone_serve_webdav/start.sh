#!/bin/sh
rclone selfupdate

# Cargar secretos desde el archivo
rclone serve webdav --addr :$WEB_PORT \
    --user $HTTP_USER \
    --pass $HTTP_PASS \
    --log-file=/tmp/rclone.log \
    --log-level $RCLONE_LOG_LEVEL \
    --umask 000 \
    --rc \
    --rc-web-gui \
    --rc-addr :$RC_PORT \
    --rc-web-gui-no-open-browser \
    --rc-user=$HTTP_USER \
    --rc-pass=$HTTP_PASS \
    $PATH_TO_SERVE