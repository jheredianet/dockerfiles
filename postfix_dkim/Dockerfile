# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv
FROM ubuntu
LABEL maintainer="@jheredianet"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ="Europe/Madrid" \
    SMTPD_TLS_CERT_FILE="fullchain.pem" \
    SMTPD_TLS_KEY_FILE="privkey.pem"

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y \
    postfix \
    sasl2-bin \
    opendkim \
    opendkim-tools \
    rsyslog \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios necesarios
RUN mkdir -p /var/run/opendkim && \
    mkdir -p /etc/postfix/sasl && \
    chown opendkim:opendkim /var/run/opendkim && \
    chmod 755 /var/run/opendkim

# Copiar configuración supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Script de inicialización
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Puertos
EXPOSE 587

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD echo QUIT | nc localhost 587 | grep -q "220"

CMD ["/init.sh"]