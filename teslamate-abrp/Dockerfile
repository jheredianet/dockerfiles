FROM python:alpine
LABEL maintainer="@jheredianet"

ENV GIT_BRANCH="custom"

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

ADD run.sh /setup/run.sh
RUN chmod +x /setup/run.sh

CMD ["ash", "/setup/run.sh"]
