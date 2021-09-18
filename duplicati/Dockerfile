FROM linuxserver/duplicati
LABEL maintainer="jchm@infoinnova.net"

RUN apt update -yy && apt install man -yy
RUN curl https://rclone.org/install.sh | bash
RUN mkdir -p /config/files/ && ln -s /config/.config/rclone/rclone.conf /config/files/rclone.conf

## https://forum.duplicati.com/t/rclone-config-for-duplicati/6225/4
## You meant configure by running “rclone config” in CMD? Currently I have several cloud remotes configured and running this way but not sure about local backend.
## Do I just go like:
## rclone.exe config
## New Remote
## Remote Name:____
## Option 17 (“Local Disk”?)
## 
## Then put the newly created “local name” into Duplicati Local repository? What exactly does this local backend do?
## I’m kind of confused between rclone’s local backend and Duplicati’s source data.
## I want to copy file from local folder to gdrive.