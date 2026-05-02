FROM node

# Configurar zona horaria a Europe/Madrid
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalar dependencias del sistema, Python y OpenSSH server
RUN export DEBIAN_FRONTEND=noninteractive && export HOMEBREW_NO_INSECURE_REDIRECT=1 \
    && apt update && apt install -y git jq nano python3.11-venv python3-pip \
        ffmpeg openssh-server sudo build-essential procps curl file sqlite3 chromium wget tzdata supervisor \
    && mkdir -p /var/run/sshd \
    && apt clean && rm -rf /var/lib/apt/lists/*


# Renombrar el usuario 'node' existente a 'bot' (ya tiene UID 1000)
RUN usermod -l bot node && \
    groupmod -n bot node && \
    usermod -d /home/bot -m bot

# Configurar sudo sin contraseña para el usuario bot
RUN echo 'bot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/bot && \
    chmod 0440 /etc/sudoers.d/bot

# Configurar SSH: puerto 2222, permitir login del usuario bot, habilitar port forwarding
RUN echo 'bot:bot' | chpasswd && \
    sed -i 's/#*Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/#*AllowTcpForwarding.*/AllowTcpForwarding yes/' /etc/ssh/sshd_config && \
    sed -i 's/#*PermitTunnel.*/PermitTunnel yes/' /etc/ssh/sshd_config && \
    sed -i 's/#*GatewayPorts.*/GatewayPorts yes/' /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config

# Generar las host keys de SSH
RUN ssh-keygen -A

# Asegurar que /var/run/sshd tenga los permisos correctos para SSH
RUN mkdir -p /var/run/sshd && \
    chmod 755 /var/run/sshd && \
    chown root:root /var/run/sshd

# Crear directorio /app
RUN mkdir -p /app && chmod 755 /app

# Crear directorio de logs para supervisord
RUN mkdir -p /var/log/supervisor && chmod 777 /var/log/supervisor

# Cambiar al usuario bot
USER bot
WORKDIR /home/bot

# Crear directorios para npm global y binarios locales
RUN mkdir -p /home/bot/.npm-global /home/bot/.local/bin

# Crear directorio para media (audio, imágenes)
RUN mkdir -p /tmp/openclaw-media/inbound

# Crear symlink en el directorio de OpenClaw
RUN mkdir -p /home/bot/.openclaw && \
    ln -s /tmp/openclaw-media /home/bot/.openclaw/media


# Configurar npm para usar el directorio del usuario para paquetes globales
RUN npm config set prefix '/home/bot/.npm-global'

# Actualizar PATH con npm global y local bin
ENV PATH="/home/bot/.npm-global/bin:/home/bot/.local/bin:${PATH}"

# Descargar e instalar notesmd-cli desde GitHub releases
RUN curl -L https://github.com/yakitrak/notesmd-cli/releases/latest/download/notesmd-linux -o /home/bot/.local/bin/notesmd && \
    chmod +x /home/bot/.local/bin/notesmd

# Instalar Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/home/bot/.bun/bin:${PATH}"

# Instalar openclaw globalmente con npm (ahora en el home del usuario)
RUN npm install -g openclaw@latest
RUN npm install -g @tobilu/qmd
RUN npm install -g agent-browser

# Crear entorno virtual Python e instalar requests
RUN python3 -m venv /home/bot/venv && \
    /home/bot/venv/bin/pip install --no-cache-dir requests

RUN /home/bot/venv/bin/pip install openai-whisper

# Copiar configuración de supervisord
COPY supervisord.conf /etc/supervisor/conf.d/openclaw.conf

# Instalar claude-cli
RUN curl -fsSL https://claude.ai/install.sh | bash

# Exponer puertos
EXPOSE 2222
EXPOSE 18789

# Volver a root para ejecutar supervisord (necesario para sshd y crear el socket)
USER root

# Copiar scripts a /app
COPY start-openclaw.sh /app/start-openclaw.sh
RUN chmod +x /app/start-openclaw.sh

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Ejecutar supervisord como PID 1
ENTRYPOINT ["/app/entrypoint.sh"]