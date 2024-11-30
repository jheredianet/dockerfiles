FROM debian:bookworm-slim

LABEL maintainer="juanheredia. jchm@infoinnova.net"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    nginx \
                    nginx-extras \
                    apache2-utils && \
                    rm -rf /var/lib/apt/lists

VOLUME /repo
EXPOSE 9000

COPY webdav.conf /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/*

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

CMD ["/bin/sh", "-c", "/entrypoint.sh"]