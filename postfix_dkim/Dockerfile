# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv
FROM ubuntu
LABEL maintainer="@jheredianet"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Madrid \
    SMTPD_TLS_CERT_FILE=fullchain.pem \
    SMTPD_TLS_KEY_FILE=privkey.pem \
    HOST_NAME=mail.dominio.com \
    DOMAIN=dominio.com

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postfix \
    sasl2-bin \
    libsasl2-2 \
    libsasl2-modules \
    opendkim \
    opendkim-tools \
    net-tools \
    netcat-openbsd \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Crear TODOS los directorios necesarios para rsyslog y postfix
RUN mkdir -p /var/run/opendkim && \
    mkdir -p /etc/opendkim/keys && \
    mkdir -p /etc/postfix/sasl && \
    mkdir -p /var/spool/postfix && \
    mkdir -p /var/spool/postfix/dev && \
    mkdir -p /var/spool/postfix/var/run && \
    chown opendkim:opendkim /var/run/opendkim && \
    chmod 755 /var/run/opendkim

# Crear archivos de configuración BASE
RUN touch /etc/postfix/main.cf /etc/postfix/master.cf && \
    touch /etc/opendkim/opendkim.conf /etc/opendkim/TrustedHosts && \
    touch /etc/opendkim/KeyTable /etc/opendkim/SigningTable

# Script de inicialización
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Puertos
EXPOSE 587

# Health check
#HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
#    CMD echo QUIT | nc localhost 587 | grep -q "220"

CMD ["/init.sh"]