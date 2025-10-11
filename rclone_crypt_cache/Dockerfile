FROM alpine:latest
LABEL maintainer="@juanheredia"

ENV CACHE_SIZE="10G" \
    SMB_USER="XXXX" \
    SMB_PASS="XXXXX" \
    ENCFS_PASS="XXXXX" \
    TZ="Europe/Madrid"

# Dependencias base
RUN apk update && apk add --no-cache \
    wget unzip fuse3 encfs ca-certificates shadow \
    gettext samba samba-common-tools

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
RUN mkdir -p /encrypted_cache /decrypted_cache /config

# Copiar configuración de nginx y scripts
COPY smb.conf.template /etc/samba/smb.conf.template
COPY rclone.conf /config/rclone.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

VOLUME ["/config", "/encrypted_cache"]
EXPOSE 445

CMD ["/start.sh"]
