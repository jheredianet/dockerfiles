FROM python:3.10-alpine
LABEL maintainer="jchm@infoinnova.net"

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

ADD run.sh /setup/run.sh
RUN chmod +x /setup/run.sh

CMD ["ash", "/setup/run.sh"]
