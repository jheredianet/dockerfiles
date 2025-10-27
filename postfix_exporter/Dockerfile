# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv
FROM debian:bookworm-slim
LABEL maintainer="@jheredianet"
LABEL description="Prometheus exporter for Postfix mail server metrics"

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Descargar e instalar postfix_exporter
#RUN wget -O /usr/local/bin/postfix_exporter \
#    https://github.com/kumina/postfix_exporter/releases/download/0.2.0/postfix_exporter \
#    && chmod +x /usr/local/bin/postfix_exporter

COPY postfix_exporter /usr/local/bin/postfix_exporter
RUN chmod +x /usr/local/bin/postfix_exporter

# Crear un usuario no privilegiado
RUN useradd --no-create-home --shell /bin/false postfix_exporter 
USER postfix_exporter

EXPOSE 9154

CMD ["/usr/local/bin/postfix_exporter", \
     "--web.listen-address=:9154", \
     "--postfix.showq_path=/var/spool/postfix/public/showq", \
     "--postfix.logfile_path=/var/log/mail.log", \
     "--log.unsupported"]
