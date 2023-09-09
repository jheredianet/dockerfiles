#!/bin/ash

#User and permissions setup
apk update
apk add --no-cache sudo tzdata curl nano
addgroup -g ${USER_GID} ${USER}
adduser ${USER} -h /home/${USER} -u ${USER_UID} -G ${USER} -D -s /bin/ash
echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER}
chmod 0440 /etc/sudoers.d/${USER}
