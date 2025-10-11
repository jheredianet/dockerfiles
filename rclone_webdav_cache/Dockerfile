FROM alpine:latest
LABEL maintainer="@jheredianet"

ENV CACHE_SIZE="10G" \
    WEBDAV_USER="XXXX" \
    WEBDAV_PASS="XXXXX" \
    WEBDAV_PORT="8080" \
    ENCFS_PASS="XXXXX" \
    TZ="Europe/Madrid"

# Dependencias base
RUN apk update && apk add --no-cache \
    wget unzip fuse3 encfs ca-certificates shadow \
    nginx apache2-utils

# Crear enlace simbólico para compatibilidad
RUN ln -s /usr/bin/fusermount3 /usr/bin/fusermount

# Configurar fuse para permitir allow_other
RUN echo "user_allow_other" >> /etc/fuse.conf

# Instalar rclone
RUN wget https://downloads.rclone.org/v1.62.0/rclone-v1.62.0-linux-amd64.zip && \
    unzip rclone-v1.62.0-linux-amd64.zip && \
    cp rclone-v1.62.0-linux-amd64/rclone /usr/bin/rclone && \
    chmod +x /usr/bin/rclone && \
    rm -rf rclone-v1.62.0*

# Crear usuario y directorios
RUN mkdir -p /encrypted_cache /decrypted_cache /config /data /run/nginx

# Copiar configuración de nginx y scripts
COPY nginx.conf /etc/nginx/nginx.conf
COPY rclone.conf /config/rclone.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

VOLUME ["/config", "/encrypted_cache", "/data"]
EXPOSE 8080

CMD ["/start.sh"]
