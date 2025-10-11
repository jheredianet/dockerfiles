#!/bin/sh
set -e
echo "Starting rclone container with encfs encryption and nginx webdav..."

# Check if ENCFS_PASSWORD is set
if [ -z "$ENCFS_PASS" ]; then
    echo "ERROR: ENCFS_PASS is not set." >&2
    exit 1
fi

# Create necessary directories
mkdir -p /encrypted_cache /decrypted_cache /rclonedata

# Crear htpasswd si no existe
if [ ! -f /etc/nginx/.htpasswd ]; then
    echo "Creando htpasswd..."
    htpasswd -bc /etc/nginx/.htpasswd "$WEBDAV_USER" "$WEBDAV_PASS"
fi

# Ajustar permisos para que nginx pueda leer
chown root:nginx /etc/nginx/.htpasswd
chmod 640 /etc/nginx/.htpasswd


# Create a password file
echo "$ENCFS_PASS" > /tmp/encfs_pass
chmod 600 /tmp/encfs_pass

# Check if encfs configuration exists
if [ ! -f /encrypted_cache/.encfs6.xml ]; then
    echo "First run: Creating new encfs filesystem..."
    yes | encfs --standard --extpass="cat /tmp/encfs_pass" /encrypted_cache /decrypted_cache
else
    echo "Mounting existing encfs filesystem..."
    encfs --extpass="cat /tmp/encfs_pass" /encrypted_cache /decrypted_cache
fi

# Check if the mount was successful
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to setup encfs filesystem" >&2
    rm -f /tmp/encfs_pass
    exit 1
fi

rm -f /tmp/encfs_pass
echo "encfs filesystem ready"

# Start rclone mount with --daemon
echo "Starting rclone mount..."
# Montar remoto con rclone (como usuario rclone) en segundo plano
rclone mount mega:/ /rclonedata \
    --config /config/rclone.conf \
    --vfs-cache-mode full \
    --vfs-cache-max-size "$CACHE_SIZE" \
    --vfs-cache-max-age 8760h \
    --vfs-read-ahead 128M \
    --vfs-read-chunk-size 128M \
    --vfs-read-chunk-size-limit off \
    --cache-dir /decrypted_cache \
    --allow-other \
    --daemon

# Wait a moment for mount to initialize
sleep 3
# Verify mount
if mountpoint -q /rclonedata; then
    echo "rclone mount successful"
else
    echo "WARNING: rclone mount may have failed"
fi

# Lanzar nginx
envsubst '$WEBDAV_PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
echo "Starting nginx WebDAV..."
nginx -g "daemon off;"