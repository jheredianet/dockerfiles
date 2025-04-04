FROM vstavrinov/acestream-service
LABEL maintainer="@jheredianet"

get_local_ips

ENV \
    P2P_PORT="8621" \
    TZ="Europe/Madrid"

USER root
RUN apt update -yy && apt upgrade -yy && \
    apt install net-tools && \
    chmod -R 777 /var/lib/nginx

USER ace
CMD mkdir --verbose /dev/shm/.ACEStream;                    \
    mkdir --verbose /dev/shm/tmp;                           \
    cp --verbose --archive /etc/nginx /dev/shm;             \
    mkdir --verbose /dev/shm/nginx/lib;                     \
    cd /dev/shm/nginx/sites-enabled;                        \
    ln --symbolic --force ../sites-available/default .; cd; \
    sed --expression="s/PORT/${PORT:=80}/"                  \
        --expression="s/ENTRY/${ENTRY:+:$ENTRY}/"           \
        --expression="s/SCHEME/${SCHEME:=https}/"           \
        --in-place /dev/shm/nginx/sites-available/default;  \
    sed -i "/listen $PORT;/a listen [::]:$PORT;"            \
        /dev/shm/nginx/sites-available/default;             \
    gunicorn --bind 0.0.0.0:3031 search:app &               \
    /usr/sbin/nginx -c /dev/shm/nginx/nginx.conf &          \
    ./start-engine                                          \
        --port ${P2P_PORT}                                  \
        --bind-all                                          \
        --use-internal-buffering 1                          \
        --live-cache-type memory                            \
        --client-console
