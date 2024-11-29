# Usar la imagen oficial de rclone
FROM rclone/rclone:latest
LABEL maintainer="@jheredianet"

COPY start.sh /start.sh
RUN chmod +x /start.sh

RUN apk update
RUN apk add rclone

# Configura el comando para ejecutar rclone serve webdav
ENTRYPOINT ["/start.sh"]
