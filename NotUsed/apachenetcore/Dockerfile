FROM httpd
LABEL maintainer="@jheredianet"

ENV NETCOREAPP_PATH=""

COPY install.sh /install.sh
RUN chmod +x /install.sh
RUN /install.sh

COPY run.sh /run.sh
RUN chmod +x /run.sh

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

