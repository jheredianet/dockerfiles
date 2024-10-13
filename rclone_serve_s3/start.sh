#!/bin/sh
rclone selfupdate
# Cargar secretos desde el archivo
rclone serve s3 --auth-key $ACCESS_KEY_ID,$SECRET_ACCESS_KEY --addr :$PORT $RCLONE_FLAGS $PATH_TO_SERVE
