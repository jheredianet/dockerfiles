# Usar la imagen oficial de rclone
FROM rclone/rclone:latest
LABEL maintainer="@jheredianet"

COPY start.sh /start.sh
RUN chmod +x /start.sh

RUN apk update
RUN apk add rclone
#RUN curl https://rclone.org/install.sh | bash

#ENV \
#    RCLONE_FLAGS="-v" \
#    TZ=${TZ}
#    PORT="9090" \
#    PATH_TO_SERVE=$PATH_TO_SERVE
#

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# Configura el comando para ejecutar rclone serve webdav
CMD ["/start.sh"]
