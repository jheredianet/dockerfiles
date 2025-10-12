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
    --uid 1000 --gid 1000 --umask 002 \
    --vfs-cache-max-size "$CACHE_SIZE" \
    --vfs-cache-max-age 8760h \
    --vfs-read-ahead 128M \
    --vfs-read-chunk-size 128M \
    --vfs-read-chunk-size-limit off \
    --cache-dir /decrypted_cache \
    --allow-other \
    --daemon

# Wait a moment for mount to initialize
sleep 1
# Verify mount
if mountpoint -q /rclonedata; then
    echo "rclone mount successful"
else
    echo "WARNING: rclone mount may have failed"
fi

# Lanzar samba
envsubst '$SMB_USER' < /etc/samba/smb.conf.template > /etc/samba/smb.conf

# Crear usuario de sistema si no existe
if ! id "$SMB_USER" >/dev/null 2>&1; then
    adduser -D -H -s /sbin/nologin "$SMB_USER"
fi

# Crear usuario Samba con la contraseña de entorno
(echo "$SMB_PASS"; echo "$SMB_PASS") | smbpasswd -s -a "$SMB_USER"
smbpasswd -e "$SMB_USER"

echo "Starting Samba service..."
smbd --foreground --no-process-group
