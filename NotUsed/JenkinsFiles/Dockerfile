FROM jenkins
COPY https.pem /var/lib/jenkins/https.pem
COPY https.key /var/lib/jenkins/https.key
USER root
RUN chmod 600 /var/lib/jenkins/https.*
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8083 --httpsCertificate=/var/lib/jenkins/https.pem --httpsPrivateKey=/var/lib/jenkins/https.key
EXPOSE 8083