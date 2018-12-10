#!/bin/bash
echo "Updating system and tools"

# Descargar/instalar Filebot
#echo "Installing Fileboot"
# https://app.filebot.net/download.php?type=deb&arch=amd64
#wget -O filebot.deb 'https://downloads.sourceforge.net/project/filebot/filebot/FileBot_4.8.2/filebot_4.8.2_amd64.deb' && \
#    dpkg -i filebot.deb && \
#    rm filebot.deb
#bash -xu <<< "$(curl -fsSL https://raw.githubusercontent.com/filebot/plugins/master/installer/deb.sh)"

# Descargar/instalar Filebot
#echo "Installing Calibre"
#wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | \
#    python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"


# Fix permissions
chown -R desktop:ubuntu /home/desktop/

# Iniciar RDP
apt -yy update && apt -yy upgrade
supervisord -n