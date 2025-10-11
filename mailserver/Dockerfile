FROM mailserver/docker-mailserver:latest
LABEL maintainer="@jheredianet"
RUN apt-get update && apt-get install -y dovecot-fts-xapian && rm -rf /var/lib/apt/lists/*
