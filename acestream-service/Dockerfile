FROM vstavrinov/acestream-service
LABEL maintainer="@jheredianet"

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
    gunicorn --bind 0.0.0.0:3031 search:app &               \
    /usr/sbin/nginx -c /dev/shm/nginx/nginx.conf &          \
    ./start-engine                                          \
        --client-console                                    \
        --bind-all                                          \
        --use-internal-buffering 1                          \
        --client-console                                    \
        --live-cache-type memory