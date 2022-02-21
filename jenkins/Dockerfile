FROM jenkins/jenkins:lts-jdk11
LABEL maintainer="jchm@infoinnova.net"
# if we want to install via apt
USER root
RUN apt-get update && \
    apt-get upgrade -yy && \
    apt-get install -yy wget rsync && \
    wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update; \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-5.0

# Add a custom file
COPY jenkins/run/jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod +x /usr/local/bin/jenkins.sh

# drop back to the regular jenkins user - good practice
USER jenkins