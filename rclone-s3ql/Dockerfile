FROM ubuntu:latest
LABEL maintainer="@jheredianet"

COPY install.sh /install.sh
RUN chmod +x /install.sh
RUN /install.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV STORAGE_URL="" \
    CACHE_S3QL_SIZE=50 \
    LOGIN_USER="" \
    LOGIN_PASSWORD="" \
    PASSPHRASE="" \
    COMPRESS_METHOD="none" \
    BACKEND_OPTIONS="" \
    S3QL_CACHE_PATH="/mnt/cache" \    
    S3QL_MOUNTPOINT="/mnt/mountpoint" \
    S3QL_METADATA_UPLOAD_INTERVAL=30 \
    S3QL_THREADS=16 \
    RCLONE_CONFIG_FILE="/config/rclone.conf" \
    RCLONE_CONFIG_NAME="RCLONECONFIGNAME" \
    RCLONE_CLOUD_PATH="/" \
    RCLONE_MOUNTPOINT="/mnt/rclone" \
    RCLONE_FLAGS="--log-level=INFO --vfs-cache-mode writes" \
    TZ="Europe/Madrid"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME ${S3QL_MOUNTPOINT}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mount"]
