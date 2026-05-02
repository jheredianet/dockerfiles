#!/bin/bash
set -e

echo "🚀 Iniciando supervisord..."

# Crear directorio de logs si no existe
mkdir -p /var/log/supervisor

# Ejecutar supervisord como PID 1
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/openclaw.conf
