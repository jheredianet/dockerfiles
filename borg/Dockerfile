FROM ubuntu:18.04
LABEL maintainer="jchm@infoinnova.net"

# Prepare environment

ADD entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ADD borg-linux64 /setup/borg
RUN chmod +x /setup/borg
RUN mv /setup/borg /usr/bin/borg
RUN ln -s /usr/bin/borg /usr/biborgn/borgfs

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

RUN ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

ENV LANG C.UTF-8
ENV \
    RCLONE_CONFIG="/config/rclone.conf" \
    CACHE_FOLDER="/mnt/cache" \
    TMPDIR="/mnt/cache/tmp" \
    RCLONE_LOG_FILE="/mnt/cache/rclone.log" \
    RESTIC_PASSWORD="MyPaSSw0rd" \
    RESTIC_REPOSITORY="rclone:foo:bar" \
    MOUNTPOINT="/mnt/mountpoint" 

VOLUME ${MOUNTPOINT}
VOLUME "/config"

ENTRYPOINT ["/setup/entrypoint.sh"]
CMD ["/bin/bash"]
