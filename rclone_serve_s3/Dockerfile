# Usar la imagen oficial de rclone
#FROM rclone/rclone:latest
FROM alpine
LABEL maintainer="@jheredianet"

COPY rclone.conf /root/.config/rclone/rclone.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

RUN apk update
RUN apk add rclone

# Configura el comando para ejecutar rclone serve s3
CMD ["/start.sh"]
