#!/bin/bash

# Function to handle termination signals
terminate() {
  echo "Stopping Nginx and tail..."
  # Stop Nginx
  nginx -s stop
  exit 0
}

# Trap termination signals
trap terminate SIGTERM SIGINT

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]
then
	htpasswd -bc /etc/nginx/htpasswd $USERNAME $PASSWORD
	echo Done.
else
    echo Using no auth.
	sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/conf.d/default.conf
	sed -i 's%auth_basic_user_file htpasswd;% %g' /etc/nginx/conf.d/default.conf
fi
mediaowner=$(ls -ld /repo | awk '{print $3}')
echo "Current /repo owner is $mediaowner"
if [ "$mediaowner" != "www-data" ]
then
    chown -R www-data:www-data /repo
fi
mediaowner=$(ls -ld /repo | awk '{print $3}')
echo "Changed /repo owner to $mediaowner"

echo "Apply www-data UID=$UID and GID=$GID"
usermod -u $UID www-data && groupmod -g $GID www-data


# log files
LOG_FILES="/var/log/nginx/webdav_access.log /var/log/nginx/webdav_error.log"
touch $LOG_FILES

# Start Nginx
echo "Starting Webdav server"
nginx -g 'daemon off;' &

echo "Webdav server running..."

echo "logs: docker exec -it webdav tail -f /var/log/nginx/webdav_access.log"
echo "error: docker exec -it webdav /var/log/nginx/webdav_error.log"
wait

# Tail the log files
#tail -f -n 20 $LOG_FILES &
#TAIL_PID=$!
#
## Wait for the tail process to finish
#wait $TAIL_PID