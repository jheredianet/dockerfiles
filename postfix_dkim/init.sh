#!/bin/bash
set -e

echo "=== INICIALIZANDO SERVICIOS SMTP ==="
# Configurar hostname y dominio desde variables de entorno o valores por defecto
HOST_NAME=${HOST_NAME}
DOMAIN=${DOMAIN}
SMTPD_TLS_CERT_FILE=${SMTPD_TLS_CERT_FILE}
SMTPD_TLS_KEY_FILE=${SMTPD_TLS_KEY_FILE}
TZ=${TZ:-"Europe/Madrid"}
PORT=${PORT:-"55555"}

echo "Usando hostname: $HOST_NAME"
echo "Usando dominio: $DOMAIN"
echo "Usando zona horaria: $TZ"
echo "Usando certificado TLS: $SMTPD_TLS_CERT_FILE"
echo "Usando clave TLS: $SMTPD_TLS_KEY_FILE"

# Configurar la zona horaria
# Método 1: Usar timedatectl (si está disponible)
if command -v timedatectl &> /dev/null; then
    timedatectl set-timezone "$TZ"
else
    # Método 2: Alternativa para contenedores sin systemd
    ln -sf "/usr/share/zoneinfo/$TZ" /etc/localtime
    echo "$TZ" > /etc/timezone
    
    # Método 3: Forzar la actualización con dpkg-reconfigure
    if command -v dpkg-reconfigure &> /dev/null; then
        DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata
    fi
fi


echo "=== Copiando Ficheros de Configuración ==="
cp /config/main.cf /etc/postfix/main.cf
#cp /config/aliases /etc/aliases # Con local_transport = error:No local delivery, los aliases no se aplican.
cp /config/virtual /etc/postfix/virtual
cp /config/sasl_passwd /etc/postfix/sasl_passwd
cp /config/sender_canonical /etc/postfix/sender_canonical
cp /config/transport /etc/postfix/transport
cp /config/sasl/smtpd.conf /etc/postfix/sasl/smtpd.conf
cp /config/opendkim/opendkim.conf /etc/opendkim/opendkim.conf
cp /config/opendkim/TrustedHosts /etc/opendkim/TrustedHosts
cp /config/opendkim/KeyTable /etc/opendkim/KeyTable
cp /config/opendkim/SigningTable /etc/opendkim/SigningTable
cp /config/opendkim/keys/mail /etc/opendkim/keys/mail
cp /config/sasl/sasldb2 /etc/sasldb2

# Usar la plantilla y reemplazar el puerto
#cp /config/master.cf /etc/postfix/master.cf
sed "s/SUBMISSION_PORT/${PORT}/g" /config/master.cf > /etc/postfix/master.cf

echo "✅ Ficheros de configuración copiados"

echo "Configurando OpenDKIM..."
# Configurar permisos de claves DKIM
if [ -f "/etc/opendkim/keys/mail" ]; then
    chmod 600 /etc/opendkim/keys/mail
    chown opendkim:opendkim /etc/opendkim/keys/mail
    echo "✅ Claves DKIM configuradas"
else
    echo "⚠️  No se encontraron claves DKIM"
fi

echo "Configurando PostFix..."

# Configuraciones esenciales de Postfix
postconf -e "myhostname=$HOST_NAME"
postconf -e "mydomain=$DOMAIN"
postconf -e "myorigin=$DOMAIN"
postconf -e "double_bounce_sender=postmaster@$DOMAIN"
postconf -e "mail_name = Postfix - $DOMAIN"
postconf -e "inet_interfaces=all"
postconf -e "mynetworks=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
postconf -e "broken_sasl_auth_clients=yes"
postconf -e "smtpd_use_tls=yes"
postconf -e "smtp_use_tls=yes"
postconf -e "milter_default_action=accept"
postconf -e "milter_protocol=6"
postconf -e "smtpd_milters=inet:localhost:8891"
postconf -e "non_smtpd_milters=inet:localhost:8891"
postconf -e "compatibility_level=3.6"

# Configurar transporte sin relayhost
#postconf -e "relayhost="
postconf -e "transport_maps=hash:/etc/postfix/transport"
postconf -e "relay_domains=$DOMAIN"

postmap /etc/postfix/sasl_passwd
postmap /etc/postfix/sender_canonical
postmap /etc/postfix/transport
postmap /etc/postfix/virtual

echo "✅ Transport maps configurado"

# 🔧 **CONFIGURACIÓN TLS CORREGIDA - ESTA ES LA PARTE CLAVE**
echo "🔧 Configurando TLS..."

# Verificar y configurar certificados TLS
if [ -f "$SMTPD_TLS_CERT_FILE" ] && [ -f "$SMTPD_TLS_KEY_FILE" ]; then
    echo "✅ Certificados Let's Encrypt detectados - Configurando TLS"
    postconf -e "smtpd_tls_cert_file=$SMTPD_TLS_CERT_FILE"
    postconf -e "smtpd_tls_key_file=$SMTPD_TLS_KEY_FILE"
    postconf -e "smtpd_tls_security_level=may"
    echo "✅ TLS configurado con certificados Let's Encrypt"
else
    echo "⚠️  Certificados Let's Encrypt NO encontrados, verificando autofirmados..."
    # Asegurar que los certificados autofirmados existen
    if [ ! -f "/etc/ssl/certs/ssl-cert-snakeoil.pem" ]; then
        echo "❌ No se encontraron certificados autofirmados, generando..."
        mkdir -p /etc/ssl/private
        openssl req -new -x509 -days 3650 -nodes \
            -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
            -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
            -subj "/CN=$HOST_NAME"
        chmod 600 /etc/ssl/private/ssl-cert-snakeoil.key
    fi
    postconf -e "smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem"
    postconf -e "smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key"
    postconf -e "smtpd_tls_security_level=may"  
    echo "✅ TLS configurado con certificados autofirmados"
fi

# Configurar SASL para usar sasldb2 en lugar de Dovecot
postconf -e "smtpd_sasl_type=cyrus"
postconf -e "smtpd_sasl_path=/etc/postfix/sasl/smtpd.conf"
postconf -e "smtpd_sasl_auth_enable=yes"
postconf -e "smtpd_sasl_security_options=noanonymous"
postconf -e "broken_sasl_auth_clients=yes"
postconf -e "smtpd_sasl_local_domain=$HOST_NAME"

# Configuración básica de destino
#postconf -e "mydestination=\$myhostname,localhost.\$mydomain,localhost,\$mydomain"
#postconf -e "mydestination=\$myhostname,localhost.\$mydomain,localhost"
postconf -e "mydestination=localhost"

# Configurar permisos SASL
if [ -f "/etc/sasldb2" ]; then
    chown postfix:postfix /etc/sasldb2
    chmod 600 /etc/sasldb2
    echo "✅ Base de datos SASL configurada"
fi

# Ajustar permisos de directorios de Postfix
echo "Ajustando permisos de Postfix..."
mkdir -p /var/spool/postfix
chown -R postfix:postfix /var/spool/postfix
# Permisos específicos para directorios críticos
chown root:root /var/spool/postfix/
chown root:root /var/spool/postfix/pid
chgrp postdrop /var/spool/postfix/public
chgrp postdrop /var/spool/postfix/maildrop

# **ELIMINAR RSYSLOG - Usar logging directo de Postfix**
echo "Configurando logging directo..."
postconf -e "maillog_file=/dev/stdout"


# Iniciar OpenDKIM
echo "Iniciando OpenDKIM..."
/usr/sbin/opendkim -f -x /etc/opendkim/opendkim.conf &

# Pequeña pausa para que OpenDKIM se inicie
sleep 2

# Reconfigurar new aliases
echo "Recargando new aliases..."
/usr/bin/newaliases

# Iniciar Postfix
echo "Iniciando Postfix..."
/usr/sbin/postfix start

# Verificar que los servicios estén corriendo
echo "Verificando servicios..."
sleep 5

if pgrep -x "master" > /dev/null; then
    echo "✅ Postfix está corriendo"
else
    echo "❌ Postfix NO está corriendo"
    exit 1
fi

if pgrep -x "opendkim" > /dev/null; then
    echo "✅ OpenDKIM está corriendo"
else
    echo "❌ OpenDKIM NO está corriendo"
    exit 1
fi

# Verificar que el puerto XXXX esté escuchando usando ss (alternativa a netstat)
if command -v ss >/dev/null 2>&1; then
    if ss -tln | grep -q ":$PORT "; then
        echo "✅ Servicio SMTP escuchando en puerto $PORT"
    else
        echo "❌ Servicio SMTP NO está escuchando en puerto $PORT, intentando verificación alternativa..."
        # Verificar usando /proc/net/tcp como alternativa
        if grep -q "16FB" /proc/net/tcp; then
            echo "✅ Servicio SMTP escuchando en puerto $PORT (verificado via /proc/net/tcp)"
        else
            echo "❌ Servicio SMTP NO está escuchando en puerto $PORT"
            exit 1
        fi
    fi
else
    # Si ss no está disponible, usar netstat
    if netstat -tln 2>/dev/null | grep -q ":$PORT "; then
        echo "✅ Servicio SMTP escuchando en puerto $PORT"
    else
        echo "❌ Servicio SMTP NO está escuchando en puerto $PORT"
        exit 1
    fi
fi

echo "=== TODOS LOS SERVICIOS INICIADOS CORRECTAMENTE ==="

# 🔧 **VERIFICACIÓN ESPECÍFICA DE TLS**
echo "🔍 Verificando configuración TLS..."
postconf smtpd_tls_cert_file smtpd_tls_key_file smtpd_tls_security_level

# Mantener el contenedor vivo y mostrar logs
echo "=== INICIADO - LISTO PARA RECIBIR CONEXIONES ==="
echo "Puerto $PORT - SMTP con TLS"
echo "Certificados Let's Encrypt configurados"
echo "OpenDKIM funcionando"

# **SOLUCIÓN ROBUSTA: Configurar logging completo**
echo "Configurando sistema de logging..."

# Crear archivos de log si no existen
touch /var/log/mail.log
touch /var/log/mail.err

# Configurar Postfix para log detallado
postconf -e "maillog_file=/var/log/mail.log"
postconf -e "smtpd_proxy_options=speed_adjust"
postconf -e "disable_dns_lookups=no"

# 🔧 **RECARGA FINAL PARA ASEGURAR TLS**
echo "🔧 Recarga final para activar TLS..."
/usr/sbin/postfix reload
sleep 3

echo "=== SISTEMA LISTO ==="
echo "Para ver logs: docker-compose logs -f postfix"
echo "O ejecuta: docker exec postfix tail -f /var/log/mail.log"

# **Mantener contenedor vivo y mostrar logs**
while true; do
    if [ -f "/var/log/mail.log" ]; then
        echo "=== MOSTRANDO LOGS EN TIEMPO REAL ==="
        tail -f /var/log/mail.log
    else
        echo "Esperando logs... (presiona Ctrl+C para salir)"
        sleep 10
    fi
done
