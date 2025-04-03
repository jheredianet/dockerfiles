FROM python:3.10
LABEL maintainer="@jheredianet"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV BASE_URL="https://download.acestream.media/linux"
ENV ACE_VERSION="3.2.3_ubuntu_22.04_x86_64_py3.10"
ENV PYTHONDONTWRITEBYTECODE=0
ENV P2P_PORT="8621"
ENV TZ="Europe/Madrid"
ENV COLUMNS=116
ENV TMP=/tmp
RUN apt update -yy && apt upgrade -yy && \
    apt install -y net-tools nload iputils-ping
RUN apt-get update; apt-get --yes install nginx; apt-get clean;  \
    ln --symbolic --force /dev/stderr /var/log/nginx/error.log;  \
    ln --symbolic --force /dev/stdout /var/log/nginx/access.log; \
    ln --symbolic --force  /dev/shm/.ACEStream .ACEStream;       \
    rmdir --verbose /var/lib/nginx;                              \
    ln --symbolic --force /dev/shm/nginx/lib  /var/lib/nginx;    \
    pip install --no-cache-dir gunicorn flask                    \
        git+https://github.com/vstavrinov/acestream_search.git
RUN useradd --shell /bin/bash --home-dir /app --create-home ace
WORKDIR /app
ADD search.py setup.cfg .

USER ace
RUN curl --progress-bar $BASE_URL/acestream_$ACE_VERSION.tar.gz | tar xzf -; \
    cd lib; unzip -o \*.egg; rm *.egg; cd;                                            \
    pip install --upgrade pip;                                                        \
    pip install --no-cache-dir --upgrade --requirement requirements.txt



CMD sed --expression="s/PORT/${PORT:=80}/"                  \
        --expression="s/ENTRY/${ENTRY:+:$ENTRY}/"           \
        --expression="s/SCHEME/${SCHEME:=https}/"           \
        --in-place /etc/nginx/sites-enabled/default;        \
    gunicorn --bind 0.0.0.0:3031 search:app &               \
    /usr/sbin/nginx -c /etc/nginx/nginx.conf &              \
    /app/start-engine                                          \
        --live-cache-type memory                            \
        --port ${P2P_PORT}                                  \
        --bind-all                                          \
        --use-internal-buffering true                       \
        --client-console