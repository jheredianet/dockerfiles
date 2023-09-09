FROM alpine:latest
LABEL maintainer="@jheredianet"

ENV TARGETARCH="linux_amd64"
ENV RELEASES_URL="https://github.com/dagu-dev/dagu/releases"
ENV VERSION=""
ENV USER="dagu"
ENV USER_UID=1000
ENV USER_GID=1000

ENV DAGU_HOST=0.0.0.0
ENV DAGU_PORT=8080


EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY install.sh /install.sh
RUN chmod +x /install.sh
RUN /install.sh


USER dagu
WORKDIR /home/dagu

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["mount"]
#CMD dagu server