#!/bin/bash
set -e

echo "=== Copiando Ficheros de Configuración ==="
cp /config/main.cf /etc/postfix/main.cf
cp /config/master.cf /etc/postfix/master.cf
cp /config/sasl/smtpd.conf /etc/postfix/sasl/smtpd.conf
cp /config/opendkim/opendkim.conf /etc/opendkim/opendkim.conf
cp /config/opendkim/TrustedHosts /etc/opendkim/TrustedHosts
cp /config/opendkim/KeyTable /etc/opendkim/KeyTable
cp /config/opendkim/SigningTable /etc/opendkim/SigningTable
cp /config/opendkim/keys/mail /etc/opendkim/keys/mail

echo "=== INICIALIZANDO SERVICIOS SMTP ==="

# Configurar permisos de claves DKIM
if [ -f "/etc/opendkim/keys/mail" ]; then
    chmod 600 /etc/opendkim/keys/mail
    chown opendkim:opendkim /etc/opendkim/keys/mail
    echo "✅ Claves DKIM configuradas"
fi

# Configurar permisos SASL
if [ -f "/etc/postfix/sasl/sasldb2" ]; then
    chown postfix:postfix /etc/postfix/sasl/sasldb2
    chmod 600 /etc/postfix/sasl/sasldb2
    echo "✅ Base de datos SASL configurada"
fi

# Verificar certificados Let's Encrypt
if [ -f "$SMTPD_TLS_CERT_FILE" ]; then
    echo "✅ Certificados Let's Encrypt detectados"
    # Configurar Postfix para usar Let's Encrypt
    postconf -e "smtpd_tls_cert_file=$SMTPD_TLS_CERT_FILE"
    postconf -e "smtpd_tls_key_file=$SMTPD_TLS_KEY_FILE"
else
    echo "⚠️  Usando certificados autofirmados"
fi

# Iniciar supervisor
echo "=== INICIANDO SUPERVISOR ==="
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf