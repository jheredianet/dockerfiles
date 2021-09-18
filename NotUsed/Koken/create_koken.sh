#!/bin/bash

echo ""

# Root check
if [[ "$UID" -ne 0 ]]; then
	echo "!! This script requires root privileges. sudo ./create_koken.sh"
	echo ""
	exit
fi

echo -n "=> Pulling Docker/Koken image (this may take a few minutes)..."
docker pull koken/koken-lemp > /dev/null
echo "done."

echo -n "=> Creating /data/koken/www and /data/koken/mysql for persistent storage..."
mkdir -p /home/juanheredia/hosting/www
mkdir -p /home/juanheredia/hosting/mysql
echo "done."

echo "=> Starting Docker container..."
CID=$(docker run --restart=always -p 8888:8080 -v /home/juanheredia/hosting/www:/usr/share/nginx/www -v /home/juanheredia/hosting:/var/lib/mysql -d koken/koken-lemp /sbin/my_init)

echo -n "=> Waiting for Koken to become available.."

RET=0
while [[ RET -lt 1 ]]; do
	IP=$(docker inspect $CID | grep IPAddress | cut -d '"' -f 4)
	echo -n "."
	sleep 5
    RET=$(curl -s http://$IP:8080 | grep "jquery" | wc -l)
done
echo "done."

echo "=> Ready! Load this server's IP address or domain in a browser to begin using Koken."
echo ""