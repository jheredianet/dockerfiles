#!/bin/bash
set -e

if [ ! -f /home/bot/.openclaw/openclaw.json ]; then
    echo "[openclaw] No configurado, iniciando en modo unconfigured..."
    exec openclaw gateway --port 18789 --bind lan --allow-unconfigured
else
    echo "[openclaw] Configurado, iniciando gateway..."
    exec openclaw gateway --port 18789 --bind lan
fi
