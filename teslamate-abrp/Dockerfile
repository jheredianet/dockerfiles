FROM python:alpine
LABEL maintainer="@jheredianet"

ENV GIT_BRANCH="develop"

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

ADD run.sh /setup/run.sh
RUN chmod +x /setup/run.sh

CMD ["ash", "/setup/run.sh"]
