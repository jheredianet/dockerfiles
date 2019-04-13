FROM ubuntu:18.04
LABEL maintainer="jchm@infoinnova.net"

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

ADD entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ADD restic_0.9.4_linux_amd64 /setup/restic
RUN chmod +x /setup/restic
RUN mv /setup/restic /usr/bin/restic

ENV \
    CONFIG="/config/rclone.conf" \
    MOUNTCONFIG="[rclone]" \
    SERVERPATH="/" \ 
    CACHE_FOLDER="/mnt/cache" \
    LOGFILE="/mnt/cache/rclone.log" \
    RESTIC_PASSWORD="MyPa$$word" \
    MOUNTPOINT="/mnt/mountpoint" 

VOLUME ${MOUNTPOINT}

ENTRYPOINT ["/setup/entrypoint.sh"]
CMD ["/bin/bash"]
